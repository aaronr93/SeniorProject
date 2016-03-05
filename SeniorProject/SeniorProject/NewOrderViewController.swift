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

class NewOrderViewController: UITableViewController {
    
    var delegate: NewOrderViewDelegate!
    
    var sectionHeaders = ["Restaurant", "Food", "Delivery"]
    var deliverySectionTitles = ["Delivered by", "Location", "Expires In"]
    let order = Order()
    
    enum Section: Int {
        case Restaurant = 0
        case Food = 1
        case Settings = 2
    }
    
    
    @IBAction func orderCancelled(sender: UIBarButtonItem) {
        delegate.cancelNewOrder(self)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3 //"Restaurant", "Food items", and "Delivery"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case Section.Restaurant.rawValue:
            return 1
        case Section.Food.rawValue:
            return order.foodItems.count
        case Section.Settings.rawValue:
            return deliverySectionTitles.count
        default: //shouldn't get here
            return 0
        }
    }
    
    //populates New Order screen headers
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case Section.Restaurant.rawValue:
            return sectionHeaders[0]
        case Section.Food.rawValue:
            return sectionHeaders[1]
        case Section.Settings.rawValue:
            return sectionHeaders[2]
        default: //shouldn't get here
            return ""
        }
    }
    
    //populates different custom cell types based on the table section
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == Section.Restaurant.rawValue {
            return cellForRestaurantSection(tableView, cellForRowAtIndexPath: indexPath)
        } else if indexPath.section == Section.Food.rawValue {
            return cellForFoodSection(tableView, cellForRowAtIndexPath: indexPath)
        } else if indexPath.section == Section.Settings.rawValue {
            return cellForDeliverySection(tableView, cellForRowAtIndexPath: indexPath)
        } else { //shouldn't get here!
            let cell: UITableViewCell! = nil
            return cell
        }
    }
    
    func cellForRestaurantSection(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let restaurantCell = tableView.dequeueReusableCellWithIdentifier("chooseRestaurantCell", forIndexPath: indexPath) as! ChooseRestaurantCell
        var restaurantName: String = order.restaurantName

        
        restaurantName.makeFirstLetterInStringUpperCase()
        
        restaurantCell.name.text = restaurantName
        return restaurantCell
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
        deliveryCell.value.text = getTextFor(indexPath.row)
        
        return deliveryCell
    }
    
    //populate row data for the Delivery section. (Value names show what each row is)
    func getTextFor(row: Int) -> String {
        var value : String = ""
        switch row {
        case Section.Restaurant.rawValue:
            value = order.deliveredBy
        case Section.Food.rawValue:
            value = order.location
        case Section.Settings.rawValue:
            value = order.expiresIn
        default:
            value = ""
        }
        return value
    }
    
    //manual row heights based on table section
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = indexPath.section
        
        switch section {
        case Section.Restaurant.rawValue: return 44
        case Section.Food.rawValue: return 60
        case Section.Settings.rawValue: return 44
        default: return 44
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case Section.Restaurant.rawValue:
            if indexPath.row == 0 {
                // Restaurant field
                performSegueWithIdentifier("chooseRestaurant", sender: self)
            }
        case Section.Food.rawValue:
            // Food item field
            performSegueWithIdentifier("editFoodItem", sender: self)
            break
        case Section.Settings.rawValue:
            switch indexPath.row {
            case 0:
                // Driver field
                performSegueWithIdentifier("chooseDriver", sender: self)
            case 1:
                // Location field
                performSegueWithIdentifier("chooseLocation", sender: self)
                break
            case 2:
                // Expiration field
                performSegueWithIdentifier("chooseExpiration", sender: self)
                break
            default:
                break
            }
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == Section.Food.rawValue {
            let headerFrame:CGRect = tableView.frame
            
            let title = UILabel(frame: CGRectMake(10, 10, 100, 30))
            title.text = "Food items"
            
            let headBttn = UIButton(type: UIButtonType.ContactAdd) as UIButton
            headBttn.enabled = true
            headBttn.titleLabel?.text = title.text
            
            headBttn.addTarget(self, action: "showAddVC:", forControlEvents: UIControlEvents.TouchUpInside)
            
            let headerView:UIView = UIView(frame: CGRectMake(0, 0, headerFrame.size.width, headerFrame.size.height))
            headerView.addSubview(title)
            headerView.addSubview(headBttn)
            headBttn.center.x = headerView.bounds.width - headBttn.frame.width
            headBttn.center.y = headBttn.center.y + 10
            
            return headerView
        } else {
            return nil
        }
    }
    
    func showAddVC(sender: UIButton) {
        performSegueWithIdentifier("editFoodItem", sender: self)
    }
    
    //manually set section header box heights
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == Section.Food.rawValue {
            // Food items section
            return 52
        } else {
            return 44
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chooseDriver" {
            let chooseDriver = segue.destinationViewController as! ChooseDriverTableViewController
            // Pass data to tell which driver should be selected by default
            chooseDriver.chosenRestaurant = order.restaurantName
        }
        if segue.identifier == "chooseExpiration" {
            let chooseExpiration = segue.destinationViewController as! ExpiresInViewController
            chooseExpiration.parent = self
            if(order.expiresIn != ""){
                chooseExpiration.selectedTime = order.expiresIn
            }
        }
        if segue.identifier == "chooseRestaurant" {
            let chooseRestaurant = segue.destinationViewController as! RestaurantsNewOrderTableViewController
            chooseRestaurant.parent = self
        }
        if segue.identifier == "editFoodItem" {
            let foodName = segue.destinationViewController as! NewFoodItemViewController
            foodName.parent = self
            let foodDescription = segue.destinationViewController as! NewFoodItemViewController
            foodDescription.parent = self
        }
    }
}



