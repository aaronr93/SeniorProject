//
//  GetThatOrderTableViewController.swift
//  SeniorProject
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
    
    let order = Order()
    let manip = InterfaceManipulation()
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBAction func driverAction(sender: UIButton) {
        if order.orderState == OrderState.Available {
            order.acquire() {
                result in
                if result {
                    // Order successfully acquired
                    self.manip.setDriverStyleFor(sender, toReflect: OrderState.Acquired)
                } else {
                    print("Error: not acquired")
                }
            }
        } else if order.orderState == OrderState.Acquired {
            order.payFor() {
                result in
                if result {
                    // Order successfully paid for
                    self.manip.setDriverStyleFor(sender, toReflect: OrderState.PaidFor)
                } else {
                    print("Error: not paid for")
                }
            }
        } else if order.orderState == OrderState.PaidFor {
            order.deliver() {
                result in
                if result {
                    // Order successfully delivered
                    sender.setTitle("Waiting for customer to reimburse", forState: UIControlState.Disabled)
                    sender.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
                    sender.enabled = false
                } else {
                    print("Error: not delivered")
                }
            }
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
        case 2: //3 -- 'deliver to', 'location', and 'expires in'
            return deliverySectionTitles.count
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
        case 0: //the chosen restaurant (should be a single row)
            return cellForRestaurantSection(tableView, cellForRowAtIndexPath: indexPath)
        case 1: //food item at row index
            return cellForFoodSection(tableView, cellForRowAtIndexPath: indexPath)
        case 2: //'deliver to', 'location', and 'expires in' row (respectively)
            return cellForDeliverySection(tableView, cellForRowAtIndexPath: indexPath)
        default: //shouldn't get here!
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
        print(indexPath.row)
        if let foodName = order.foodItems[indexPath.row].name{
            print(foodName)
            foodCell.foodItem.text = foodName
        }else{
            foodCell.foodItem.text = ""
        }
        
        if let foodDescription = order.foodItems[indexPath.row].description{
            foodCell.foodDescription.text = foodDescription
        }else{
            foodCell.foodDescription.text = ""
        }
        
        return foodCell
    }
    
    func cellForDeliverySection(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let deliveryCell = tableView.dequeueReusableCellWithIdentifier("deliveryCell", forIndexPath: indexPath) as! DeliveryItemCell
        deliveryCell.deliveryTitle.text = deliverySectionTitles[indexPath.row]
        deliveryCell.value.text = fillValuesBasedOn(indexPath.row)
        return deliveryCell
    }
    
    //sets the values of the three rows in the 'Delivery' section of the table
    func fillValuesBasedOn(row: Int) -> String {
        var value : String = ""
        switch row {
        case 0: //first row -- 'deliver to' data
            value = order.deliverTo
        case 1: //second row -- 'location' data
            value = order.location
        case 2: //third row -- time until order expiration
            value = order.expiresIn
        default:
            value = ""
        }
        return value
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
            if success == true{
                print(self.order.foodItems)
                self.tableView.reloadData()
            }else{
                print("items could not be retrieved")
            }
        })
        manip.setDriverStyleFor(actionButton, toReflect: order.orderState)
    }

}
