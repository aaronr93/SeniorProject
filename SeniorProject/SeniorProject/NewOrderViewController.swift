//
//  NewOrderViewController.swift
//  SeniorProject
//
//  Created by Seth Loew on 1/28/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

protocol NewOrderViewDelegate {
    func cancelNewOrder(newOrderVC: NewOrderViewController)
}

class ChooseRestaurantCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
}

class NewFoodItemCell: UITableViewCell {
    @IBOutlet weak var foodItem: UILabel!
    @IBOutlet weak var foodDescription: UILabel!
}

class NewDeliveryItemCell: UITableViewCell {
    @IBOutlet weak var deliveryTitle: UILabel!
    @IBOutlet weak var value: UILabel!
}

class NewOrderViewController: UITableViewController, ChooseDriverDelegate {
    
    var delegate: NewOrderViewDelegate!
    
    var sectionHeaders = ["Restaurant", "Food", "Delivery"]
    var deliverySectionTitles = ["Delivered by", "Location", "Expires In"]
    let order = Order()
    
    @IBAction func orderCancelled(sender: UIBarButtonItem) {
        delegate.cancelNewOrder(self)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return order.foodItems.count
        case 2:
            return deliverySectionTitles.count
        default:
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return sectionHeaders[0]
        case 1:
            return sectionHeaders[1]
        case 2:
            return sectionHeaders[2]
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return cellForRestaurantSection(tableView, cellForRowAtIndexPath: indexPath)
        } else if indexPath.section == 1 {
            return cellForFoodSection(tableView, cellForRowAtIndexPath: indexPath)
        } else if indexPath.section == 2 {
            return cellForDeliverySection(tableView, cellForRowAtIndexPath: indexPath)
        } else {
            let cell: UITableViewCell! = nil
            return cell
        }
    }
    
    func cellForRestaurantSection(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let restaurantCell = tableView.dequeueReusableCellWithIdentifier("chooseRestaurantCell", forIndexPath: indexPath) as! ChooseRestaurantCell
        let restaurantName: String = order.restaurantName
        //makeSentenceCase(&restaurantName)
        restaurantCell.name.text = restaurantName
        return restaurantCell
    }
    
    func makeSentenceCase(inout str: String) {
        str.replaceRange(str.startIndex...str.startIndex, with: String(str[str.startIndex]).capitalizedString)
    }
    
    func cellForFoodSection(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let foodCell = tableView.dequeueReusableCellWithIdentifier("newFoodCell", forIndexPath: indexPath) as! NewFoodItemCell
        foodCell.foodItem.text = order.foodItems[indexPath.row]["food"]["name"] as? String
        foodCell.foodDescription.text = order.foodItems[indexPath.row]["description"] as? String
        return foodCell
    }
    
    func cellForDeliverySection(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let deliveryCell = tableView.dequeueReusableCellWithIdentifier("newDeliveryCell", forIndexPath: indexPath) as! NewDeliveryItemCell
        deliveryCell.deliveryTitle.text = deliverySectionTitles[indexPath.row]
        deliveryCell.value.text = fillValuesBasedOn(indexPath.row)
        return deliveryCell
    }
    
    func fillValuesBasedOn(row: Int) -> String {
        var value : String = ""
        switch row {
        case 0:
            value = order.deliveredBy
        case 1:
            value = order.location
        case 2:
            value = order.expiresIn
        default:
            value = ""
        }
        return value
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = indexPath.section
        
        switch section {
        case 0: return 44
        case 1: return 60
        case 2: return 44
        default: return 44
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                // Restaurant field
                //performSegueWithIdentifier("chooseRestaurant", sender: self)
            }
        case 1:
            // Food item field
            //performSegueWithIdentifier("editFoodItem", sender: self)
            break
        case 2:
            switch indexPath.row {
            case 0:
                // Driver field
                performSegueWithIdentifier("chooseDriver", sender: self)
            case 1:
                // Location field
                //performSegueWithIdentifier("chooseLocation", sender: self)
                break
            case 2:
                // Expiration field
                //performSegueWithIdentifier("chooseExpiration", sender: self)
                break
            default:
                break
            }
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func returnFromSubScreen(chooseDriver: ChooseDriverTableViewController) {
        order.deliveredBy = chooseDriver.chosenDriver
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chooseDriver" {
            let chooseDriver = segue.destinationViewController as! ChooseDriverTableViewController
            chooseDriver.delegate = self
        }
    }
}



