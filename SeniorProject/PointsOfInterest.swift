//
//  PointsOfInterest.swift
//  Foodini
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
    
    func distancetoUserSortFunc(location1: MKMapItem, location2: MKMapItem, usersLocation: CLLocation) -> Bool {
        let firstDistance = usersLocation.distanceFromLocation(CLLocation(latitude: location1.placemark.coordinate.latitude, longitude: location1.placemark.coordinate.longitude))
        let secondDistance = usersLocation.distanceFromLocation(CLLocation(latitude: location2.placemark.coordinate.latitude, longitude: location2.placemark.coordinate.longitude))
        return firstDistance < secondDistance
    }
    
    func searchFor(query: String, inRegion region: MKCoordinateRegion, withLocation loc: CLLocation, completion: (success: Bool) -> Void) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = query
        request.region = region
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler { (response: MKLocalSearchResponse?, error: NSError?) -> Void in
            if error == nil {
                let mapItems = (response?.mapItems)! as [MKMapItem]
                
                let sortedMapItems = mapItems.sort { (loc1, loc2) -> Bool in
                    self.distancetoUserSortFunc(loc1, location2: loc2, usersLocation: loc)
                }
                
                let current = PFGeoPoint(location: loc)
                for item in sortedMapItems {
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