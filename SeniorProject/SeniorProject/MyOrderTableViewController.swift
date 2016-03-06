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
    
    enum Section: Int {
        case Restaurant = 0
        case Food = 1
        case Settings = 2
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3 //'restaurant', 'food' and 'delivery' respectively
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case Section.Restaurant.rawValue: //single restaurant allowed (or 'select a restaurant' if none yet)
            return 1
        case Section.Food.rawValue: //2nd section lists food items
            return order.foodItems.count
        case Section.Settings.rawValue: //3 rows in 3rd section -- 'delivered by', 'location', and 'expires in'
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
        case 0: //list deliverer
            value = order.deliveredBy
        case 1: //delivery location
            value = order.location
        case 2: //time unti order expiration
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
        //get orders sent to the driver
        order.itemsForOrderQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let items = objects {
                    for item in items {
                        self.order.addFoodItem(item)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }

}
