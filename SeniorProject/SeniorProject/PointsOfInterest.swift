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

class PointsOfInterest: NSObject {
    
    let currentLocation = CurrentLocation()
    var restaurants = [Restaurant]()
    
    func searchFor(query: String, completion: (success: Bool) -> Void) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = query
        request.region = currentLocation.region
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response: MKLocalSearchResponse?, error: NSError?) -> Void in
            if error == nil {
                let mapItems = (response?.mapItems)! as [MKMapItem]
                for item in mapItems {
                    let name = item.name
                    let placemark = item.placemark
                    var address: String?
                    if let houseNumber = placemark.subThoroughfare {
                        address?.appendContentsOf(houseNumber)
                    }
                    if let streetAddress = placemark.thoroughfare {
                        address?.appendContentsOf(" ")
                        address?.appendContentsOf(streetAddress)
                    }
                    let city = placemark.subAdministrativeArea
                    let state = placemark.administrativeArea
                    let zip = placemark.postalCode
                    let tempRestaurant = Restaurant(name: name!, loc: placemark)
                    tempRestaurant.address = address
                    tempRestaurant.city = city
                    tempRestaurant.state = state
                    tempRestaurant.zip = zip
                    self.restaurants.append(tempRestaurant)
                }
                completion(success: true)
            } else {
                logError("Error searching for nearby Restaurants: \(error)")
                completion(success: false)
            }
        }
    }
    
    func saveRestaurantsToParse(completion: (success: Bool) -> Void) {
        let existingRestaurants = DriverRestaurantPreferences()
        existingRestaurants.getFromParse() { result in
            if result {
                // Got all the restaurants that are already stored in Parse.
                let existingNames = existingRestaurants.getRestaurantNames()
                let existingCoords = existingRestaurants.getRestaurantCoords()
                for location in self.restaurants {
                    // For each restaurant that we're trying to add, which we found via Maps
                    let name = location.name
                    let coord = PFGeoPoint(location: location.loc.location)
                    
                    if !existingNames.contains(name) && !self.isNear(existingCoords, comparator: coord) {
                        // If Parse does not already have this restaurant, add it
                        let obj = PFObject(className: "Restaurant")
                        
                        if let address = location.address {
                            obj["address"] = address
                        }
                        
                        if let city = location.city {
                            obj["city"] = city
                        }
                        
                        if let state = location.state {
                            obj["state"] = state
                        }
                        
                        if let zip = location.zip {
                            obj["zip"] = zip
                        }
                        
                        obj["name"] = name
                        obj["locationCoord"] = coord
                        
                        obj.saveEventually()
                    } // If Parse already has this restaurant, ignore it
                }
                
                completion(success: true)
            }
        }
    }
    
    func isNear(basis: [PFGeoPoint], comparator: PFGeoPoint) -> Bool {
        for item in basis {
            let longitudeDiff = abs(item.longitude - comparator.longitude)
            let latitudeDiff = abs(item.latitude - comparator.latitude)
            if longitudeDiff < 0.1 && latitudeDiff < 0.1 {
                // They're very near each other. Only count one.
                return true
            } else {
                return false
            }
        }
        return false
    }
    
}