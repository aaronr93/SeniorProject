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

extension String{
    mutating func makeFirstLetterInStringUpperCase() {
        self.replaceRange(self.startIndex...self.startIndex, with: String(self[self.startIndex]).capitalizedString)
    }
}

class GetThatOrderTableViewController: UITableViewController {
    
    var sectionHeaders = ["Restaurant", "Food", "Delivery"]
    var deliverySectionTitles = ["Deliver To", "Location", "Expires In"]
    var buttonTitle = ["I'll get that", "Pay for food", "I've arrived at the delivery location", "Order complete","Acquired ✓"]
    let order = Order()
    
    @IBAction func driverAction(sender: UIButton) {
        switch order.orderState {
        case OrderState.Available:
            order.acquire(){
                result in
                if result {
                    //order successfully acquired
                    sender.setTitle(self.buttonTitle[4], forState: UIControlState.Normal)
                    sender.backgroundColor = UIColor.greenColor()
                    sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                } else {
                    //error not acquired
                }
            }
        case OrderState.Acquired:
            if sender.titleLabel?.text != self.buttonTitle[4]{
                order.payFor()
                sender.setTitle(buttonTitle[2], forState: UIControlState.Normal)
            }
        case OrderState.PaidFor:
            order.deliver()
            sender.enabled = false
            sender.setTitle(buttonTitle[3], forState: UIControlState.Disabled)
        default:
            break
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
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
        switch section{
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
