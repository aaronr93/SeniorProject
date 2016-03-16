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
    var isAnyDriver: Bool = false
    var location: String = ""
    var expiresIn: String = ""
    var foodItems = [Food]()
    var orderState = OrderState.Available
    
    let itemsForOrderQuery = PFQuery(className:"OrderedItems")
    
    func addFoodItem(toAdd: Food) {
        if !foodItems.contains( {$0.name == toAdd.name} ) {
            foodItems.append(toAdd)
        } else {
            logError("Food item already exists.")
        }
    }
    
    func removeFoodItem(toRemove: Food) {
        if let removeIndex = foodItems.indexOf( {$0.name == toRemove.name} ) {
            foodItems.removeAtIndex(removeIndex)
        } else {
            logError("Food item to remove does not exist.")
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
            if !succeeded{
                logError("parse items save failed :(")
            }
        })
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
                logError("Error: \(error!) \(error!.userInfo)")
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
                        logError("Couldn't get Driver to Deliver")
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
                logError("must select a driver")
            }
        }
        else{
            logError("must select a restaurant")
        }
        
    }
    
    func newOrderSetup(newOrder: PFObject,completion: (success: Bool) -> Void){
        let restaurant = PFObject(withoutDataWithClassName: "Restaurant", objectId: self.restaurantId)
        
        newOrder["restaurant"] = restaurant
        
        //need to add future date based on selection picked
        newOrder["expirationDate"] = getActualTimeFromNow()
        
        self.createDestination(newOrder) {
            result in
            if result {
                // Destination successful
                newOrder.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if error != nil {
                        completion(success: false)
                        logError(error!)
                        return
                    } else {
                        var foodCount = 0
                        for foodItem in self.foodItems{
                            let newFoodItem = PFObject(className: "OrderedItems")
                            newFoodItem["description"] = foodItem.description
                            newFoodItem["order"] = newOrder
                            let doesFoodExistQuery = PFQuery(className: "Food")
                            doesFoodExistQuery.whereKey("restaurant", equalTo: restaurant)
                            doesFoodExistQuery.whereKey("name", equalTo: foodItem.name!.lowercaseString)
                            doesFoodExistQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                                if error == nil{
                                    if let matchedFoodItems = results{
                                        if !matchedFoodItems.isEmpty{
                                            //add to ordered items but not food
                                            newFoodItem["food"] = matchedFoodItems.first
                                            logError(foodItem.name!.lowercaseString + " already added to foodclass")
                                            newFoodItem.saveInBackgroundWithBlock({ (success, error) -> Void in
                                                if success{
                                                    if foodCount == self.foodItems.count{
                                                        //then this is the last item in the array
                                                        completion(success: true)
                                                        return
                                                    }
                                                }
                                            })
                                        }else{
                                            //add to ordered itsm and food
                                            let foodItemForClass = PFObject(className: "Food")
                                            foodItemForClass["name"] = foodItem.name!.lowercaseString
                                            foodItemForClass["restaurant"] = restaurant
                                            foodItemForClass.saveInBackgroundWithBlock({ (success, error) -> Void in
                                                if success{
                                                    newFoodItem["food"] = foodItemForClass
                                                    newFoodItem.saveInBackgroundWithBlock({ (success, error) -> Void in
                                                        if success{
                                                            if foodCount == self.foodItems.count{
                                                                //then this is the last item in the array
                                                                completion(success: true)
                                                                return
                                                            }
                                                        }
                                                    })
                                                }else{
                                                    logError("error saving food")
                                                }
                                            })
                                        }
                                    }
                                }else{
                                    logError("error getting food item match")
                                }
                            })
                            foodCount += 1
                        }
                        
                        if(!self.deliveredByID.isEmpty){
                            //notify the driver
                            let name:String = (PFUser.currentUser()?.username!)!
                            let notification = Notification(content: "\(name) sent you an order!", sendToID: self.deliveredByID)
                            notification.push()
                        }
                        
                    }
                })
            } else {
                logError("Error: destination unsuccessful")
                completion(success: false)
                return
            }
        }

    }
    
    func getActualTimeFromNow() -> NSDate {
        switch expiresIn {
        case "15 minutes":
            return NSDate().addHours(1)
        case "30 minutes":
            return NSDate().addHours(1)
        case "1 hour":
            return NSDate().addHours(1)
        case "2 hours":
            return NSDate().addHours(2)
        case "3 hours":
            return NSDate().addHours(3)
        case "4 hours":
            return NSDate().addHours(4)
        default:
            return NSDate().addHours(1)
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
                    logError(error!)
                    completion(success: false)
                }
            }
        }else{
            logError("location must be entered")
            completion(success: false)
        }
    }
    
    func acquire(completion: (Bool) -> ()) {
        // Sent when a driver picks up an order.
        
        let query = PFQuery(className: "Order")
        query.getObjectInBackgroundWithId(orderID) {
            (order: PFObject?, error: NSError?) -> Void in
            if error != nil {
                logError(error!)
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
                logError(error!)
            } else if let order = order {
                order["OrderState"] = "PaidFor"
                self.orderState = OrderState.PaidFor
                order.saveInBackground()
                //send notification
                let name:String = (PFUser.currentUser()?.username!)!
                let notification = Notification(content: "\(name) paid for your order!", sendToID: self.deliverToID)
                notification.push()
                
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
                logError(error!)
            } else if let order = order {
                order["OrderState"] = "Delivered"
                self.orderState = OrderState.Delivered
                order.saveInBackground()
                //send notification
                let name:String = (PFUser.currentUser()?.username!)!
                let notification = Notification(content: "\(name) is at the delivery location!", sendToID: self.deliverToID)
                notification.push()
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
                logError(error!)
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
                logError(error!)
            } else if let order = order {
                order["OrderState"] = "Deleted"
                self.orderState = OrderState.Deleted
                order.saveInBackground()
                completion(true)
            }
        }
    }
}

