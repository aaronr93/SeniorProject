//
//  Order.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/21/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import Parse

enum OrderState {
    case Available
    case Acquired
    case PaidFor
    case Delivered
}

class Order {
    var restaurantName: String = ""
    var orderID: String = ""
    var deliverTo: String = ""
    var location: String = ""
    var expiresIn: String = ""
    var foodItems = [PFObject]()
    var orderState = OrderState.Available
    let itemsForOrderQuery = PFQuery(className:"OrderedItems")
    
    init() {
        itemsForOrderQuery.includeKey("food")
        itemsForOrderQuery.includeKey("order")
        itemsForOrderQuery.whereKey("order", equalTo: PFObject(withoutDataWithClassName: "Order", objectId: orderID))
    }
    
    func addFoodItem(toAdd: PFObject) {
        if !foodItems.contains(toAdd) {
            foodItems.append(toAdd)
        } else {
            print("Food item already exists.")
        }
    }
    
    func removeFoodItem(toRemove: PFObject) {
        if let removeIndex = foodItems.indexOf(toRemove) {
            foodItems.removeAtIndex(removeIndex)
        } else {
            print("Food item to remove does not exist.")
        }
    }
    
    func getFromParse() {
        itemsForOrderQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let items = objects {
                    for item in items {
                        self.addFoodItem(item)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func acquire() {
        // Sent when a driver picks up an order. Call Parse stuff here.
        print("Acquired")
        orderState = OrderState.Acquired
    }
    
    func payFor() {
        // Sent when a driver pays for an order. Call Parse stuff here.
        print("Paid for")
        orderState = OrderState.PaidFor
    }
    
    func deliver() {
        // Sent when a driver delivers an order. Call Parse stuff here.
        print("Delivered")
        orderState = OrderState.Delivered
    }
}

