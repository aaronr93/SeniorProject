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
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func getCurrentLocation() -> CLLocation {
        print(locationManager.location)
        return locationManager.location!
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last! as CLLocation
        currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
    }
}