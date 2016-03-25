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
    
    var restaurants = [Restaurant]()
    
    func searchFor(query: String, aroundLocation loc: CurrentLocation, completion: (success: Bool) -> Void) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = query
        request.region = loc.region
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response: MKLocalSearchResponse?, error: NSError?) -> Void in
            if error == nil {
                let mapItems = (response?.mapItems)! as [MKMapItem]
                let current = PFGeoPoint(location: loc.location)
                for item in mapItems {
                    let name = item.name
                    let placemark = item.placemark
                    let loc = placemark.location
                    let geoPoint = PFGeoPoint(location: loc)
                    let tempRestaurant = Restaurant(name: name!)
                    tempRestaurant.loc = geoPoint
                    tempRestaurant.dist = geoPoint.distanceInMilesTo(current)
                    self.restaurants.append(tempRestaurant)
                }
                completion(success: true)
            } else {
                logError("Error searching for nearby Restaurants: \(error)")
                completion(success: false)
            }
        }
    }
    
    func clear() {
        restaurants.removeAll()
    }
    
}

extension PFGeoPoint {
    func isNear(thisPoint comparator: PFGeoPoint, within radius: Double) -> Bool {
        if self.distanceInMilesTo(comparator) < radius {
            return true
        } else {
            return false
        }
    }
    
    func isNearAnyOf(thesePoints comparators: [PFGeoPoint], within radius: Double) -> Bool {
        for item in comparators {
            if self.distanceInMilesTo(item) < radius {
                return true
            } else {
                return false
            }
        }
        return false
    }
}