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
    var restaurant: Restaurant
    var orderID: String = ""
    var isAnyDriver: Bool = false
    var expiresIn: String = ""
    var expiresHours : Int = 0
    var expiresMinutes : Int = 0
    
    var deliverTo: String = ""
    var deliverToID: String = ""
    
    var deliveredBy: String = ""
    var deliveredByID: String = ""
    
    var destination: Destination! = Destination()
    var foodItems = [Food]()
    var orderState = OrderState.Available
    
    init() {
        restaurant = Restaurant(name: "Select restaurant...")
    }
    
    let itemsForOrderQuery = PFQuery(className: "OrderedItems")
    
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
    
    func removeFoodItem(index: Int) {
        foodItems.removeAtIndex(index)
    }
    
    func foodItemsToPFObjects(foodItems: [Food]) -> [PFObject] {
        let order = PFOrder(withoutDataWithClassName: "Order", objectId: self.orderID)
        var parseFoodItems = [PFObject]()
        for foodItem in foodItems {
            let orderedItem = PFOrderedItems()
            orderedItem.order = order
            orderedItem.foodDescription = foodItem.description!
            parseFoodItems += [orderedItem]
        }
        return parseFoodItems
    }
    
    func addFoodItemsToOrderInDB(foodItems: [Food]) {
        let parseFoodItems = foodItemsToPFObjects(foodItems)
        PFObject.saveAllInBackground(parseFoodItems, block: {
            (succeeded: Bool, error: NSError?) -> Void in
            if !succeeded{
                logError("parse items save failed :(")
            }
        })
    }
    
    func getFoodItemsFromParse(completion: (success: Bool) -> Void) {
        itemsForOrderQuery.includeKey("order").whereKey("order", equalTo: PFObject(withoutDataWithClassName: "Order", objectId: orderID))
        itemsForOrderQuery.includeKey("food")
        itemsForOrderQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let items = objects {
                    for item in items {
                        
                        var foodName = ""
                        var foodDescription = ""
                        
                        let item = item as! PFOrderedItems
                        let food = item.food as! PFFood
                        foodName = food.name
                        foodDescription = item.foodDescription
                        
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
        
        if foodItems.isEmpty {
            logError("You haven't added any food items!")
            completion(success: false)
            return
        }
        
        if restaurant.name == "Select restaurant..." {
            logError("You haven't selected a restaurant!")
            completion(success: false)
            return
        }
        
        let newOrder = PFOrder()
        
        newOrder.OrderingUser = PFUser.currentUser()!
        newOrder.OrderState = "Available"
        newOrder.isAnyDriver = isAnyDriver
        
        if !isAnyDriver {
            
            let getDriverToDeliver = PFUser.query()!
            getDriverToDeliver.whereKey("objectId", equalTo: deliveredByID)
            
            //get the driver
            getDriverToDeliver.getFirstObjectInBackgroundWithBlock { (user, error) -> Void in
                if error == nil {
                    newOrder.driverToDeliver = user!
                    
                    // Finish creating order
                    self.newOrderSetup(newOrder, completion: { (success) -> Void in
                        if success {
                            completion(success: true)
                        } else {
                            logError("Failed to create the order.")
                            completion(success: false)
                        }
                    })
                    
                } else {
                    logError("Couldn't find your driver to deliver.")
                    completion(success: false)
                }
            }

        } else if isAnyDriver {
            
            self.newOrderSetup(newOrder, completion: { (success) -> Void in
                if success {
                    completion(success: true)
                } else {
                    completion(success: false)
                }
            })
        }
        else {
            logError("You haven't selected a driver to deliver!")
        }
        
    }
    
    func newOrderSetup(newOrder: PFOrder, completion: (success: Bool) -> Void) {
        
        newOrder.restaurantName = restaurant.name
        newOrder.restaurantLoc = restaurant.loc!
        newOrder.expirationDate = getActualTimeFromNow()
        
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
                        for foodItem in self.foodItems {
                            
                            let newFoodItem = PFOrderedItems()
                            newFoodItem.foodDescription = foodItem.description!
                            newFoodItem.order = newOrder
                            
                            let doesFoodExistQuery = PFQuery(className: "Food")
                            doesFoodExistQuery.whereKey("restaurant", equalTo: self.restaurant.name)
                            doesFoodExistQuery.whereKey("name", equalTo: foodItem.name!.lowercaseString)
                            
                            doesFoodExistQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                                if error == nil {
                                    if let matchedFoodItems = results {
                                        if !matchedFoodItems.isEmpty {
                                            // add to ordered items but not food
                                            newFoodItem.food = matchedFoodItems.first!
                                            
                                            newFoodItem.saveInBackgroundWithBlock({ (success, error) -> Void in
                                                if success {
                                                    if foodCount == self.foodItems.count {
                                                        // Then this is the last item in the array
                                                        completion(success: true)
                                                        return
                                                    }
                                                } else {
                                                    logError("Couldn't save new food items to database.\n\(error)")
                                                }
                                            })
                                        } else {
                                            // Add to ordered item and food
                                            let foodItemForClass = PFFood()
                                            foodItemForClass.name = foodItem.name!.lowercaseString
                                            foodItemForClass.restaurant = self.restaurant.name
                                            
                                            foodItemForClass.saveInBackgroundWithBlock({ (success, error) -> Void in
                                                if success {
                                                    newFoodItem.food = foodItemForClass
                                                    newFoodItem.saveInBackgroundWithBlock({ (success, error) -> Void in
                                                        if success {
                                                            if foodCount == self.foodItems.count {
                                                                // Then this is the last item in the array
                                                                completion(success: true)
                                                                return
                                                            }
                                                        } else {
                                                            logError("Couldn't save new food items to database.\n\(error)")
                                                        }
                                                    })
                                                } else {
                                                    logError("Error saving food: \(error)")
                                                }
                                            })
                                        }
                                    }
                                } else {
                                    logError("Error getting food item match")
                                }
                            })
                            foodCount += 1
                        } // End for-loop for foodItems
                        
                        if (!self.deliveredByID.isEmpty) {
                            // Notify the driver
                            let name: String = (PFUser.currentUser()?.username!)!
                            let notification = Notification(content: "\(name) sent you an order!", sendToID: self.deliveredByID)
                            notification.push()
                        }
                        
                    }
                })
            } else {
                logError("Failed to create a new destination.")
                completion(success: false)
                return
            }
        }

    }
    
    func getActualTimeFromNow() -> NSDate {
        let now = NSDate()
        
        let totalMinutes = (expiresHours * 60) + expiresMinutes
        
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(.Minute, value: totalMinutes, toDate: now, options: [])
        return date!
    }
    
    func createDestination(newOrder: PFOrder, completion: (success: Bool) -> Void) {
        let destinationQuery = PFQuery(className: PFDestination.parseClassName())
        if !destination.id.isEmpty {
            destinationQuery.whereKey("objectId", equalTo: destination.id)
            destinationQuery.getFirstObjectInBackgroundWithBlock {
                (object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    // Set the chosen destination for the order.
                    if let dest = object {
                        newOrder.destination = dest
                        completion(success: true)
                    }
                } else {
                    // Log details of the failure
                    logError("Couldn't set the destination for the order. Error:\n\(error!)")
                    completion(success: false)
                }
            }
        } else {
            logError("A destination must be entered")
            completion(success: false)
        }
    }
    
    func acquire(completion: (Bool) -> ()) {
        // Sent when a driver picks up an order.
        
        let query = PFQuery(className: PFOrder.parseClassName())
        query.getObjectInBackgroundWithId(orderID) {
            (order: PFObject?, error: NSError?) -> Void in
            if error != nil {
                logError("Failed to retrieve order from Parse. Error:\n\(error!)")
            } else if let order = order as? PFOrder {
                // Changes fields in Parse to reflect new order state.
                order.isAnyDriver = false
                order.OrderState = "Acquired"
                order.driverToDeliver = PFUser.currentUser()!
                self.orderState = OrderState.Acquired
                order.saveInBackground()
                
                // Send notification
                let name: String = (PFUser.currentUser()?.username!)!
                let notification = Notification(content: "\(name) acquired your order!", sendToID: self.deliverToID)
                notification.push()
                
                completion(true)
            }
        }
    }
    
    func payFor(completion: (Bool) -> ()) {
        // Sent when a driver pays for an order. Call Parse stuff here.
        
        let query = PFQuery(className: PFOrder.parseClassName())
        query.getObjectInBackgroundWithId(orderID) {
            (order: PFObject?, error: NSError?) -> Void in
            if error != nil {
                logError("Failed to retrieve order from Parse. Error:\n\(error!)")
            } else if let order = order as? PFOrder {
                order.OrderState = "PaidFor"
                self.orderState = OrderState.PaidFor
                order.saveInBackground()
                
                // Send notification
                let name: String = (PFUser.currentUser()?.username!)!
                let notification = Notification(content: "\(name) paid for your order!", sendToID: self.deliverToID)
                notification.push()
                
                completion(true)
                
            }
        }
    }
    
    func deliver(completion: (Bool) -> ()) {
        // Sent when a driver delivers an order. Call Parse stuff here.
        
        let query = PFQuery(className: PFOrder.parseClassName())
        query.getObjectInBackgroundWithId(orderID) {
            (order: PFObject?, error: NSError?) -> Void in
            if error != nil {
                logError("Failed to retrieve order from Parse. Error:\n\(error!)")
            } else if let order = order as? PFOrder {
                order.OrderState = "Delivered"
                self.orderState = OrderState.Delivered
                order.saveInBackground()
                
                // Send notification
                let name: String = (PFUser.currentUser()?.username!)!
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
                logError("Failed to retrieve order from Parse. Error:\n\(error!)")
            } else if let order = order as? PFOrder {
                order.OrderState = "Completed"
                self.orderState = OrderState.Completed
                order.saveInBackground()
                
                // Send notification
                let name: String = (PFUser.currentUser()?.username!)!
                let notification = Notification(content: "\(name) reimbursed you for your order!", sendToID: self.deliveredByID)
                notification.push()
                
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
                logError("Failed to retrieve order from Parse. Error:\n\(error!)")
            } else if let order = order as? PFOrder {
                order.OrderState = "Deleted"
                self.orderState = OrderState.Deleted
                order.saveInBackground()
                
                // Send notification
                let name: String = (PFUser.currentUser()?.objectId)!
                let notification = Notification(content: "You deleted your order.", sendToID: name)
                notification.push()
                
                completion(true)
            }
        }
    }
}

