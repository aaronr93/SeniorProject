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
import Parse

class CurrentLocation: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var coordinate = CLLocationCoordinate2D()
    var loc: CLLocation!
    var region = MKCoordinateRegion()
    
    override init() {
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationFromParse() -> CLLocation {
        let user = PFUser.currentUser()!
        let geoData = user.valueForKey("locationCoord") as! PFGeoPoint
        let geoDataCL = CLLocation(latitude: geoData.latitude, longitude: geoData.longitude)
        return geoDataCL
    }
    
    func updateParseLocation() {
        if loc.horizontalAccuracy <= 100 {
            let geoData = PFGeoPoint(location: loc)
            let user = PFUser.currentUser()!
            user.setValue(geoData, forKey: "locationCoord")
            user.saveInBackground()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let temp = locations.last! as CLLocation
        
        let locAge: NSTimeInterval = -temp.timestamp.timeIntervalSinceNow
        if locAge > 5.0 { return }
        if temp.horizontalAccuracy < 0 { return }
        
        if loc == nil || loc.horizontalAccuracy > temp.horizontalAccuracy {
            loc = temp
            coordinate = loc.coordinate
            region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
            if temp.horizontalAccuracy <= locationManager.desiredAccuracy {
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        logError("didFailWithError: \(error.description)")
    }
}