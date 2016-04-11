//
//  MyOrderTableViewController.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 2/23/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit

class MyOrderTableViewController: UITableViewController {
    
    var sectionHeaders = ["Restaurant", "Food", "Delivery"]
    var deliverySectionTitles = ["Delivered By", "Location", "Expires In"]
    
    var order = Order()
    let manip = InterfaceManipulation()
    var index: NSIndexPath?
    
    var delegate: MyOrdersViewController!
    
    enum Section: Int {
        case Restaurant = 0
        case Food = 1
        case Settings = 2
    }
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBAction func buttonPress(sender: UIButton) {
        if order.orderState == OrderState.Available {
            // The order will be cancelled.
            
            let refreshAlert = UIAlertController(title: "Cancel", message: "Are you sure you want to cancel this order?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { (action: UIAlertAction!) in
                sender.enabled = false
                self.order.delete() { result in
                    if result {
                        // Order successfully deleted
                        self.manip.setCustomerStyleFor(sender, toReflect: OrderState.Deleted)
                    } else {
                        logError("Order not deleted")
                    }
                }
            }))
            refreshAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            presentViewController(refreshAlert, animated: true, completion: nil)
            
        } else if order.orderState == OrderState.Delivered {
            // The driver will be reimbursed.
            
            let refreshAlert = UIAlertController(title: "Reimburse", message: "Enter the dollar amount to reimburse.", preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addTextFieldWithConfigurationHandler({ (field: UITextField) in
                field.placeholder = "$##.##"
                field.keyboardType = .DecimalPad
            })
            refreshAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                sender.enabled = false
                self.order.reimburse() { result in
                    if result {
                        // Driver successfully reimbursed
                        self.manip.setCustomerStyleFor(sender, toReflect: OrderState.Completed)
                    } else {
                        logError("Order not reimbursed")
                    }
                }
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3 //'restaurant', 'food' and 'delivery' respectively
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case Section.Restaurant.rawValue:
                //single restaurant allowed (or 'select a restaurant' if none yet)
                return 1
            case Section.Food.rawValue:
                //2nd section lists food items
                return order.foodItems.count
            case Section.Settings.rawValue:
                //3 rows in 3rd section -- 'delivered by', 'location', and 'expires in'
                return deliverySectionTitles.count
            default:
                return 0
        }
        
    }
    
    //hard-coded section headers from the String array sectionHeaders (above)
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case Section.Restaurant.rawValue:
            return sectionHeaders[0]
        case Section.Food.rawValue:
            return sectionHeaders[1]
        case Section.Settings.rawValue:
            return sectionHeaders[2]
        default: //shouln't get here
            return ""
        }
    }
    
    //display custom row data based on the section in question--restaurant, food, or delivery
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.Restaurant.rawValue: //list restaurant choice (only 1 row)
            return cellForRestaurantSection(tableView, cellForRowAtIndexPath: indexPath)
        case Section.Food.rawValue: //list food item in respective row
            return cellForFoodSection(tableView, cellForRowAtIndexPath: indexPath)
        case Section.Settings.rawValue: //list one of the three 'delivery' rows ('delivered by', 'location', or 'expires in')
            return cellForDeliverySection(tableView, cellForRowAtIndexPath: indexPath)
        default: //shouldn't get here
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
        if let foodName = order.foodItems[indexPath.row].name {
            foodCell.foodItem.text! = foodName
        } else {
            foodCell.foodItem.text = ""
        }
        
        if let foodDescription = order.foodItems[indexPath.row].description {
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
                value = order.deliveredBy
            case 1:
                // Delivery destination
                value = order.destination.name
            case 2:
                // Time until the order expires
                value = order.expiresIn
            default:
                value = ""
                logError("Error with Delivery Settings cell")
        }
        
        deliveryCell.value.text = value
        return deliveryCell
    }
    
    //manually set row heights for different sections in the table
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = indexPath.section
        
        switch section {
            case Section.Restaurant.rawValue: return 44
            case Section.Food.rawValue: return 60
            case Section.Settings.rawValue: return 44
            default: return 44
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        manip.setCustomerStyleFor(actionButton, toReflect: order.orderState)
        //get orders sent to the driver
        order.getFoodItemsFromParse({
            (success: Bool) in
            if success == true {
                self.tableView.reloadData()
            } else {
                logError("items could not be retrieved")
            }
        })
    }

}







