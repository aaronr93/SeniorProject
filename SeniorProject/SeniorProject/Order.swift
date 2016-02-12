//
//  Order.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/12/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation

class Order {
    
    var timeCreated: String?
    var restaurant: String?
    var food: [String] = []
    var foodItems: String?
    var deliveredBy: String?
    var deliveryLocation: String?
    var expireTime: String?
    
    func addToFoodItems(item: String) {
        food.append(item)
    }
    
    func addToFoodItems(item: [String]) {
        food.appendContentsOf(item)
    }
    
    func removeFromFoodItems(item: String) -> Bool {
        if food.contains(item) {
            food.removeAtIndex(food.indexOf(item)!)
            return true
        } else {
            NSLog("Array \"Food\" does not contain the item \(item)")
            return false
        }
    }
    
    func numberOfFoodItems() -> Int {
        return food.count
    }
    
    func combineFoodItemsToString() {
        // Make foodItems a string of the values of "food" concatenated.
    }
    
}