//
//  GetThatOrderTableViewController.swift
//  Foodini
//
//  Created by Michael Kytka on 2/20/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class RestaurantCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
}

class FoodItemCell: UITableViewCell {
    @IBOutlet weak var foodItem: UILabel!
    @IBOutlet weak var foodDescription: UILabel!
}

class DeliveryItemCell: UITableViewCell {
    @IBOutlet weak var deliveryTitle: UILabel!
    @IBOutlet weak var value: UILabel!
}

extension String {
    mutating func makeFirstLetterInStringUpperCase() {
        self.replaceRange(self.startIndex...self.startIndex, with: String(self[self.startIndex]).capitalizedString)
    }
}

class GetThatOrderTableViewController: UITableViewController {
    
    var sectionHeaders = ["Restaurant", "Food", "Delivery"]
    var deliverySectionTitles = ["Deliver To", "Location", "Expires In"]
    
    var driverDelegate: DriverOrdersViewController?
    var myOrdersDelegate: MyOrdersViewController?
    
    var order = Order()
    let manip = InterfaceManipulation()
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBAction func driverAction(sender: UIButton) {
        if order.orderState == OrderState.Available {
            
            let alert = UIAlertController(title: "Pick up order", message: "Are you sure you want to pick up this order?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                sender.enabled = false
                self.order.acquire() { result in
                    if result {
                        // Order successfully acquired
                        if self.driverDelegate != nil {
                            self.manip.driver_setAcquiredStyleFor(sender)
                        } else if self.myOrdersDelegate != nil {
                            self.manip.setDriverStyleFor(sender, toReflect: OrderState.Acquired)
                        }
                    } else {
                        NSLog("Order not acquired")
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            
        } else if order.orderState == OrderState.Acquired {
            
            let alert = UIAlertController(title: "Pay", message: "Enter the order's dollar amount from the receipt.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler({ (field: UITextField) in
                field.placeholder = "$##.##"
                field.keyboardType = .DecimalPad
            })
            alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: { (action: UIAlertAction!) in
                sender.enabled = false
                self.order.payFor() { result in
                    if result {
                        // Order successfully paid for
                        self.manip.setDriverStyleFor(sender, toReflect: OrderState.PaidFor)
                    } else {
                        NSLog("Order not paid for")
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)

        } else if order.orderState == OrderState.PaidFor {
            
            let alert = UIAlertController(title: "Delivery location", message: "Are you sure you have arrived at the delivery location?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                sender.enabled = false
                self.order.deliver() { result in
                    if result {
                        // Order successfully delivered
                        sender.setTitle("Waiting for customer to reimburse", forState: UIControlState.Disabled)
                        sender.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
                        sender.enabled = false
                    } else {
                        NSLog("Order not delivered")
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            
        } else if order.orderState == OrderState.Completed {
            manip.setDriverStyleFor(sender, toReflect: OrderState.Completed)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: //single 'restaurant' cell
            return 1
        case 1: //number of food items in order
            return order.foodItems.count
        case 2:
            // If the order hasn't been acquired, show expiration date.
            // otherwise, the order doesn't expire.
            if order.orderState != OrderState.Available {
                return 2
            } else {
                return 3
            }
        default:
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: //'Deliver to'
            return sectionHeaders[0]
        case 1: //'Location'
            return sectionHeaders[1]
        case 2: //'Expires in'
            return sectionHeaders[2]
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                //the chosen restaurant (should be a single row)
                return cellForRestaurantSection(tableView, cellForRowAtIndexPath: indexPath)
            case 1:
                //food item at row index
                return cellForFoodSection(tableView, cellForRowAtIndexPath: indexPath)
            case 2:
                //'deliver to', 'location', and 'expires in' row (respectively)
                return cellForDeliverySection(tableView, cellForRowAtIndexPath: indexPath)
            default:
                //shouldn't get here!
                let cell: UITableViewCell! = nil
                return cell
        }
    }
    
    
    func cellForRestaurantSection(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let restaurantCell = tableView.dequeueReusableCellWithIdentifier("restaurantCell", forIndexPath: indexPath) as! RestaurantCell
        
        var restaurantName: String = order.restaurant.name
        restaurantName.makeFirstLetterInStringUpperCase()
        restaurantCell.name.text = restaurantName
        
        return restaurantCell
    }
    
    
    func cellForFoodSection(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let foodCell = tableView.dequeueReusableCellWithIdentifier("foodCell", forIndexPath: indexPath) as! FoodItemCell
        let row = indexPath.row
        
        if let foodName = order.foodItems[row].name {
            foodCell.foodItem.text = foodName
        } else {
            foodCell.foodItem.text = ""
        }
        
        if let foodDescription = order.foodItems[row].description {
            foodCell.foodDescription.text = foodDescription
        } else {
            foodCell.foodDescription.text = ""
        }
        
        return foodCell
    }
    
    func cellForDeliverySection(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let deliveryCell = tableView.dequeueReusableCellWithIdentifier("deliveryCell", forIndexPath: indexPath) as! DeliveryItemCell
        let row = indexPath.row
        
        deliveryCell.deliveryTitle.text = deliverySectionTitles[row]
        
        var value = ""
        switch row {
        case 0:
            // Value for the driver to deliver (Any or specific)
            value = order.deliverTo
        case 1:
            // Delivery destination
            value = order.destination.name
        case 2:
            // Time until the order expires
            value = order.expiresIn
        default:
            value = ""
            NSLog("Error with Delivery Settings cell")
        }
        
        deliveryCell.value.text = value
        return deliveryCell
    }
    
    //manually set row heights for different sections in the table
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = indexPath.section
        
        switch section {
            case 0: return 44 //'Restaurant'
            case 1: return 60 //'Food'
            case 2: return 44 //'Delivery'
            default: return 44 //shouldn't get here
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //get orders sent to the driver
        order.getFoodItemsFromParse({
            (success: Bool) in
            if success == true {
                self.tableView.reloadData()
                self.manip.setDriverStyleFor(self.actionButton, toReflect: self.order.orderState)
            } else {
                NSLog("Food items could not be retrieved")
            }
        })
        self.manip.setDriverStyleFor(self.actionButton, toReflect: self.order.orderState)
    }

}
