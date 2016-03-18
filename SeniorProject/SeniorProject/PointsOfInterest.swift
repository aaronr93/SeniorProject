//
//  PointsOfInterest.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 3/17/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import Parse

class PointsOfInterest: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    var location = CLLocation()
    var region = MKCoordinateRegion()
    
    var restaurants = [Restaurant]()
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func searchFor(query: String) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = query
        request.region = region
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response: MKLocalSearchResponse?, error: NSError?) -> Void in
            if error == nil {
                let mapItems = (response?.mapItems)! as [MKMapItem]
                for item in mapItems {
                    let name = item.name
                    let placemark = item.placemark
                    let tempRestaurant = Restaurant(name: name!, loc: placemark)
                    self.restaurants.append(tempRestaurant)
                    print("Name: \(name)")
                }
            } else {
                logError("Error searching for nearby Restaurants: \(error)")
            }
        }
    }
    
    func saveRestaurantsToParse(completion: (success: Bool) -> Void) {
        for loc in restaurants {
            let name = loc.name
            let coord = loc.loc.location
            let obj = PFObject(className: "Restaurant")
            obj["name"] = name
            obj["locationCoord"] = coord
            obj.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if error == nil {
                    // The save succeeded
                    completion(success: true)
                } else {
                    logError("Error saving new Restaurant: \(error)")
                    completion(success: false)
                }
            })
        }

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last! as CLLocation
        currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15))
    }
}