//
//  DriverRestaurantPreferences.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/19/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation

class DriverRestaurantPreferences {
    var active: Bool = false
    var restaurants: [String] = []
    var expirationTime: NSDate = NSDate()
    
    func addRestaurant(toAdd: String) {
        if !restaurants.contains(toAdd) {
            restaurants.append(toAdd)
        } else {
            print("Restaurant already exists in preferences.")
        }
    }
    
    func removeRestaurant(toRemove: String) {
        if let removeIndex = restaurants.indexOf(toRemove) {
            restaurants.removeAtIndex(removeIndex)
        } else {
            print("Restaurant to remove does not exist in preferences.")
        }
    }
    
    func setActive() {
        if restaurants.count > 0 {
            active = true
        } else {
            active = false
            print("You cannot become active if no restaurants are selected")
        }
    }
    
    func setInactive() {
        active = false
    }
    
    func getFromParse() {
        let parseRestaurants = ["Sheetz", "McDonald's", "Primanti's", "Elephant & Castle"]
        restaurants = parseRestaurants
    }
    
    func updateParse() {
        
    }
    
}