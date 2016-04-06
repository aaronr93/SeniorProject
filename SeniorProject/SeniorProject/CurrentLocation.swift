//
//  CurrentLocation.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 3/21/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class CurrentLocation: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    var location = CLLocation()
    var region = MKCoordinateRegion()
    
    override init() {
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        }
    }
    
    func getCurrentLocation() -> CLLocation {
        if let loc = locationManager.location {
            print(locationManager.location!.coordinate.latitude, locationManager.location!.coordinate.longitude)
            return loc
        } else {
            print("Did the default thing")
            return CLLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last! as CLLocation
        currentLocation = location.coordinate
        region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        logError("didFailWithError: \(error.description)")
    }
}