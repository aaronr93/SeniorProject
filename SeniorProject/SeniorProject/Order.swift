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
    case Completed
    case Deleted
}

class Order {
    var restaurantId: String = ""
    var restaurantName: String = "Select a Restaurant"
    var orderID: String = ""
    var deliverTo: String = ""
    var deliverToID: String = ""
    var destinationID: String = ""
    var deliveredBy: String = ""
    var deliveredByID: String = ""
    var location: String = ""
    var expiresIn: String = ""
    var foodItems = [Food]()
    var orderState = OrderState.Available
    
    let itemsForOrderQuery = PFQuery(className:"OrderedItems")
    
    func addFoodItem(toAdd: Food) {
        if !foodItems.contains( {$0.name == toAdd.name} ) {
            foodItems.append(toAdd)
        } else {
            print("Food item already exists.")
        }
    }
    
    func removeFoodItem(toRemove: Food) {
        if let removeIndex = foodItems.indexOf( {$0.name == toRemove.name} ) {
            foodItems.removeAtIndex(removeIndex)
        } else {
            print("Food item to remove does not exist.")
        }
    }
    
    func foodItemsToPFObjects(foodItems: [Food]) -> [PFObject]{
        let order = PFObject(withoutDataWithObjectId: self.orderID)
        var parseFoodItems = [PFObject]()
        for foodItem in foodItems{
            let orderedItem = PFObject(className: "OrderedItems")
            //var food = PFObject(className: "Food")
            orderedItem["order"] = order
            orderedItem["description"] = foodItem.description
            parseFoodItems += [orderedItem]
        }
        return parseFoodItems
    }
    
    func addFoodItemsToOrderInDB(foodItems: [Food]){
        let parseFoodItems = foodItemsToPFObjects(foodItems)
        PFObject.saveAllInBackground(parseFoodItems, block: {
            (succeeded: Bool, error: NSError?) -> Void in
            if succeeded{
                print("parse items save succeeded")
            }else{
                print("parse items save failed :(")
            }
        })
        print(parseFoodItems)
    }
    
    func getFoodItemsFromParse(completion: (success: Bool) -> Void) {
        itemsForOrderQuery.whereKey("order", equalTo: PFObject(withoutDataWithClassName: "Order", objectId: orderID))
        itemsForOrderQuery.includeKey("food")
        itemsForOrderQuery.includeKey("order")
        itemsForOrderQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let items = objects {
                    for item in items {
                        var foodName = ""
                        var foodDescription = ""
                        if let food = item["food"]{
                            if let fn = food["name"] as? String{
                                foodName = fn
                            }
                        }
                        if let fd = item["description"] as? String{
                            foodDescription = fd
                        }
                        let foodItem = Food(name: foodName, description: foodDescription)
                        self.addFoodItem(foodItem)
                    }
                    completion(success: true)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completion(success: false)
            }
        }
    }
    
    func create(completion: (success: Bool) -> Void) {
        // Sent when a customer submits an order.
        
        if foodItems.isEmpty{
            completion(success: false)
            return
        }
        
        if restaurantId != ""{
            let newOrder = PFObject(className: "Order")
            
            newOrder["OrderingUser"] = PFUser.currentUser()!
            newOrder["OrderState"] = "Available"
            //if specific driver
            if !deliveredByID.isEmpty{
                let getDriverToDeliver = PFUser.query()!
                getDriverToDeliver.whereKey("objectId", equalTo: deliveredByID)
                
                //get the driver
                getDriverToDeliver.getFirstObjectInBackgroundWithBlock { (user, error) -> Void in
                    if error == nil{
                        newOrder["isAnyDriver"] = false
                        newOrder["driverToDeliver"] = user
                        //finish order
                        self.newOrderSetup(newOrder, completion: { (success) -> Void in
                            if success{
                                completion(success: true)
                                return
                            }else{
                                completion(success: false)
                                return
                            }
                        })
                    }else{
                        print("error")
                        completion(success: false)
                        return
                    }
                }
                //if any driver
            }else if deliveredByID.isEmpty && deliveredBy == "Any driver"{
                newOrder["isAnyDriver"] = true
                self.newOrderSetup(newOrder, completion: { (success) -> Void in
                    if success{
                        completion(success: true)
                    }else{
                        completion(success: false)
                    }
                })
            }
            else{
                print("must select a driver")
            }
        }
        else{
            print("must select a restaurant")
        }
        
    }
    
    func newOrderSetup(newOrder: PFObject,completion: (success: Bool) -> Void){
        let restaurant = PFObject(withoutDataWithClassName: "Restaurant", objectId: self.restaurantId)
        
        newOrder["restaurant"] = restaurant
        
        //need to add future date based on selection picked
        newOrder["expirationDate"] = NSDate()
        
        self.createDestination(newOrder) {
            result in
            if result {
                // Destination successful
                print("Success in creating destination for order")
                newOrder.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if error != nil {
                        completion(success: false)
                        print(error)
                        return
                    } else {
                        print("Success saving order!")
                        /*for foodItem in self.foodItems{
                            let newFoodItem = PFObject(className: "OrderedItems")
                            newFoodItem["order"] = newOrder
                            let doesFoodExistQuery = PFQuery(className: "Food")
                            doesFoodExistQuery.whereKey("restaurant", equalTo: restaurant)
                            doesFoodExistQuery.whereKey("name", equalTo: foodItem.name!.lowercaseString)
                            doesFoodExistQuery.getFirstObjectInBackgroundWithBlock({ (food, error) -> Void in
                                
                            })
                        }*/
                        completion(success: true)
                    }
                })
            } else {
                print("Error: destination unsuccessful")
                completion(success: false)
                return
            }
        }

    }
    
    func createDestination(newOrder: PFObject, completion: (success: Bool) -> Void) {
        let destinationQuery = PFQuery(className: "CustomerDestinations")
        if !destinationID.isEmpty{
            destinationQuery.whereKey("objectId", equalTo: destinationID)
            destinationQuery.getFirstObjectInBackgroundWithBlock {
                (object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    // The find succeeded.
                    // Do something with the found objects
                    if let item = object {
                        newOrder["destination"] = item
                        completion(success: true)
                    }
                } else {
                    // Log details of the failure
                    print(error)
                }
            }
        }else{
            print("location must be entered")
            completion(success: false)
        }
    }
    
    func acquire(completion: (Bool) -> ()) {
        // Sent when a driver picks up an order.
        
        let query = PFQuery(className: "Order")
        query.getObjectInBackgroundWithId(orderID) {
            (order: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let order = order {
                // Changes fields in Parse to reflect new order state.
                order["isAnyDriver"] = false
                order["OrderState"] = "Acquired"
                order["driverToDeliver"] = PFUser.currentUser()!
                self.orderState = OrderState.Acquired
                order.saveInBackground()
                completion(true)
            }
        }
    }
    
    func payFor(completion: (Bool) -> ()) {
        // Sent when a driver pays for an order. Call Parse stuff here.
        
        let query = PFQuery(className: "Order")
        query.getObjectInBackgroundWithId(orderID) {
            (order: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let order = order {
                order["OrderState"] = "PaidFor"
                self.orderState = OrderState.PaidFor
                order.saveInBackground()
                completion(true)
            }
        }
    }
    
    func deliver(completion: (Bool) -> ()) {
        // Sent when a driver delivers an order. Call Parse stuff here.
        
        let query = PFQuery(className: "Order")
        query.getObjectInBackgroundWithId(orderID) {
            (order: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let order = order {
                order["OrderState"] = "Delivered"
                self.orderState = OrderState.Delivered
                order.saveInBackground()
                completion(true)
            }
        }
    }
    
    func reimburse(completion: (Bool) -> ()) {
        // Sent when a customer reimburses a driver. Call Parse stuff here.
        
        let query = PFQuery(className: "Order")
        query.getObjectInBackgroundWithId(orderID) {
            (order: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let order = order {
                order["OrderState"] = "Completed"
                self.orderState = OrderState.Completed
                order.saveInBackground()
                completion(true)
            }
        }
    }
    
    func delete(completion: (Bool) -> ()) {
        // Sent when a customer deletes an order. Call Parse stuff here.
        // NOTE: orders can only be deleted before a driver has picked up an order.
        
        let query = PFQuery(className: "Order")
        query.getObjectInBackgroundWithId(orderID) {
            (order: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let order = order {
                order["OrderState"] = "Deleted"
                self.orderState = OrderState.Deleted
                order.saveInBackground()
                completion(true)
            }
        }
    }
}

