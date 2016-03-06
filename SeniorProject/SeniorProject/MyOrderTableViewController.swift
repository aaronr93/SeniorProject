//
//  MyOrderTableViewController.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 2/23/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class MyOrderTableViewController: UITableViewController {
    
    var sectionHeaders = ["Restaurant", "Food", "Delivery"]
    var deliverySectionTitles = ["Delivered By", "Location", "Expires In"]
    
    let order = Order()
    let manip = InterfaceManipulation()
    
    enum Section: Int {
        case Restaurant = 0
        case Food = 1
        case Settings = 2
    }
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBAction func buttonPress(sender: UIButton) {
        if order.orderState == OrderState.Available {
            // The order will be cancelled.
            order.delete() {
                result in
                if result {
                    // Order successfully deleted
                    self.manip.setCustomerStyleFor(sender, toReflect: OrderState.Deleted)
                } else {
                    //error, not deleted
                    print("Error: not deleted")
                }
            }
        } else if order.orderState == OrderState.Delivered {
            // The driver will be reimbursed.
            order.reimburse() {
                result in
                if result {
                    // Driver successfully reimbursed
                    self.manip.setCustomerStyleFor(sender, toReflect: OrderState.Completed)
                } else {
                    //error, not reimbursed
                }
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3 //'restaurant', 'food' and 'delivery' respectively
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case Section.Restaurant.rawValue:
            return 1
        case Section.Food.rawValue:
            return order.foodItems.count
        case Section.Settings.rawValue:
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
        if indexPath.section == Section.Restaurant.rawValue {
            return cellForRestaurantSection(tableView, cellForRowAtIndexPath: indexPath)
        } else if indexPath.section == Section.Food.rawValue {
            return cellForFoodSection(tableView, cellForRowAtIndexPath: indexPath)
        } else if indexPath.section == Section.Settings.rawValue {
            return cellForDeliverySection(tableView, cellForRowAtIndexPath: indexPath)
        } else { //shouldn't get here
            let cell: UITableViewCell! = nil
            return cell
        }
    }
    
    func cellForRestaurantSection(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let restaurantCell = tableView.dequeueReusableCellWithIdentifier("restaurantCell", forIndexPath: indexPath) as! RestaurantCell
        var restaurantName: String = order.restaurantName
        restaurantName.makeFirstLetterInStringUpperCase()
        restaurantCell.name.text = restaurantName
        return restaurantCell
    }
    
    func cellForFoodSection(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let foodCell = tableView.dequeueReusableCellWithIdentifier("foodCell", forIndexPath: indexPath) as! FoodItemCell
        foodCell.foodItem.text = order.foodItems[indexPath.row]["food"]["name"] as? String
        foodCell.foodDescription.text = order.foodItems[indexPath.row]["description"] as? String
        return foodCell
    }
    
    func cellForDeliverySection(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let deliveryCell = tableView.dequeueReusableCellWithIdentifier("deliveryCell", forIndexPath: indexPath) as! DeliveryItemCell
        deliveryCell.deliveryTitle.text = deliverySectionTitles[indexPath.row]
        deliveryCell.value.text = fillValuesBasedOn(indexPath.row)
        return deliveryCell
    }
    
    //fill cell data for the 'delivery' section of the table
    func fillValuesBasedOn(row: Int) -> String {
        var value : String = ""
        switch row {
        case Section.Restaurant.rawValue:
            value = order.deliverTo
        case Section.Food.rawValue:
            value = order.location
        case Section.Settings.rawValue:
            value = order.expiresIn
        default: //shouldn't get here
            value = ""
        }
        return value
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        order.getFoodItemsFromParse() {
            result in
            if result {
                // Food items successfully retrieved
                self.tableView.reloadData()
            } else {
                // Error, didn't get food items
            }
        }
        
        manip.setCustomerStyleFor(actionButton, toReflect: order.orderState)
    }

}







