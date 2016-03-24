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
    func orderSaved(newOrderVC: NewOrderViewController)
}

class ChooseRestaurantCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
}

class NewFoodItemCell: UITableViewCell {
    @IBOutlet weak var foodItem: UILabel!
    @IBOutlet weak var foodDescription: UILabel!
}

class NewOrderViewController: UITableViewController, NewFoodItemViewDelegate, ChooseDriverDelegate, RestaurantsNewOrderDelegate, DeliveryLocationDelegate {
    
    var delegate: NewOrderViewDelegate!
    
    var sectionHeaders = ["Restaurant", "Food", "Delivery"]
    var deliverySectionTitles = ["Delivered by", "Location", "Expires in"]
    var deliverySectionPrompts = ["Select a driver...", "Select delivery location...", "Select expiration time..."]
    let order = Order()
    var current = NSIndexPath()
    
    var currentLocation = CurrentLocation()
    
    enum Section: Int {
        case Restaurant = 0
        case Food = 1
        case Settings = 2
    }
    
    func cancelNewItem(newFoodItemVC: NewFoodItemTableViewController){
        newFoodItemVC.navigationController?.popViewControllerAnimated(true)
    }
    
    func editNewItem(newFoodItemVC: NewFoodItemTableViewController) {
        if let index = newFoodItemVC.index{
            if !newFoodItemVC.foodNameText.isEmpty{
                order.foodItems[index].name = newFoodItemVC.foodNameText
            }
            if !newFoodItemVC.foodDescriptionText.isEmpty{
                order.foodItems[index].description = newFoodItemVC.foodDescriptionText
            }
        }
        self.tableView.reloadData()
        newFoodItemVC.navigationController?.popViewControllerAnimated(true)
    }
    
    // Delegate method for New Food Item
    func saveNewItem(newFoodItemVC: NewFoodItemTableViewController){
        let foodItem = Food(name: newFoodItemVC.foodNameText, description: newFoodItemVC.foodDescriptionText)
        order.addFoodItem(foodItem)
        self.tableView.reloadData()
        newFoodItemVC.navigationController?.popViewControllerAnimated(true)
    }
    
    // Delegate method for Choose Driver
    func saveDriverToDeliver(chooseDriverVC: ChooseDriverTableViewController) {
        self.order.deliveredByID = chooseDriverVC.chosenDriverID
        self.order.deliveredBy = chooseDriverVC.chosenDriver
        self.order.isAnyDriver = chooseDriverVC.isAnyDriver
        self.tableView.reloadData()
        chooseDriverVC.navigationController?.popViewControllerAnimated(true)
    }
    
    // Delegate method for Choose Restaurant
    func saveRestaurant(restaurantsNewOrderVC: RestaurantsNewOrderTableViewController) {
        self.tableView.reloadData()
        restaurantsNewOrderVC.navigationController?.popViewControllerAnimated(true)
    }
    
    // Delegate method for Choose Delivery Location
    func saveDeliveryLocation(deliveryLocationVC: DeliveryLocationTableViewController) {
        self.tableView.reloadData()
        order.destination = deliveryLocationVC.destination
        deliveryLocationVC.navigationController?.popViewControllerAnimated(true)
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
                // single, static "select a restaurant" cell (for now)
                return 1
            case Section.Food.rawValue:
                //based on number of food items in order
                return order.foodItems.count
            case Section.Settings.rawValue:
                // 3 -- 'delivered by', 'location', and 'expires in'
                return deliverySectionTitles.count
            default:
                //shouldn't get here
                return 0
        }
    }
    
    //populates New Order screen headers
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case Section.Restaurant.rawValue:
                //"Restaurant" header
                return sectionHeaders[0]
            case Section.Food.rawValue:
                //"Food items" header
                return sectionHeaders[1]
            case Section.Settings.rawValue:
                //"Delivery" header
                return sectionHeaders[2]
            default:
                //shouldn't get here
                return ""
        }
    }
    
    //populates different custom cell types based on the table section
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
            case Section.Restaurant.rawValue:
                //static "select a restaurant" cell (for now)
                return cellForRestaurantSection(tableView, cellForRowAtIndexPath: indexPath)
            case Section.Food.rawValue:
                //2nd section has the food info
                return cellForFoodSection(tableView, cellForRowAtIndexPath: indexPath)
            case Section.Settings.rawValue:
                //3rd section has delivery info
                return cellForDeliverySection(tableView, cellForRowAtIndexPath: indexPath)
            default:
                //shouldn't get here!
                let cell: UITableViewCell! = nil
                return cell
        }
    }
    
    func cellForRestaurantSection(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let restaurantCell = tableView.dequeueReusableCellWithIdentifier("chooseRestaurantCell", forIndexPath: indexPath) as! ChooseRestaurantCell
        var restaurantName: String = order.restaurant.name

        if restaurantName == "Select a Restaurant" {
            restaurantCell.name.textColor = UIColor.grayColor()
        } else {
            restaurantCell.name.textColor = UIColor.blackColor()
        }
        
        restaurantName.makeFirstLetterInStringUpperCase()
        restaurantCell.name.text = restaurantName
        return restaurantCell
    }
    
    func cellForFoodSection(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let foodCell = tableView.dequeueReusableCellWithIdentifier("newFoodCell", forIndexPath: indexPath) as! NewFoodItemCell
  
        foodCell.foodItem.text = order.foodItems[indexPath.row].name!
        foodCell.foodDescription.text = order.foodItems[indexPath.row].description!
        
        return foodCell
    }
    
    func cellForDeliverySection(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let deliveryCell = tableView.dequeueReusableCellWithIdentifier("newDeliveryCell", forIndexPath: indexPath)
        
        let data = getTextFor(indexPath.row)
        if data.isEmpty {
            deliveryCell.textLabel!.text! = deliverySectionPrompts[indexPath.row]
            deliveryCell.textLabel!.textColor = UIColor.grayColor()
            deliveryCell.detailTextLabel!.text! = ""
        } else {
            deliveryCell.textLabel!.text! = deliverySectionTitles[indexPath.row]
            deliveryCell.textLabel!.textColor = UIColor.blackColor()
            deliveryCell.detailTextLabel!.text! = getTextFor(indexPath.row)
        }
        
        return deliveryCell
    }
    
    // Populate row data for the Delivery section. (Value names show what each row is)
    func getTextFor(row: Int) -> String {
        var value : String = ""
        switch row {
            case 0:
                value = order.deliveredBy
            case 1:
                value = order.destination.name
            case 2:
                value = order.expiresIn
            default:
                value = ""
        }
        return value
    }
    
    // Manual row heights based on table section
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
                current = indexPath
                performSegueWithIdentifier("chooseRestaurant", sender: self)
            }
        case Section.Food.rawValue:
            // Food item field
            performSegueWithIdentifier("editFoodItem", sender: "fromCell")
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
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == Section.Food.rawValue {
            let headBttn = UIButton(type: UIButtonType.ContactAdd) as UIButton
            headBttn.enabled = true
            headBttn.titleLabel?.text = "Food items"
            headBttn.addTarget(self, action: "showAddVC:", forControlEvents: UIControlEvents.TouchUpInside)
            
            view.addSubview(headBttn)
            
            headBttn.center.x = view.bounds.width - headBttn.frame.width
            headBttn.center.y = headBttn.center.y + 10
        }
    }
    
    func showAddVC(sender: UIButton) {
        performSegueWithIdentifier("editFoodItem", sender: "fromPlus")
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        if indexPath.section == Section.Restaurant.rawValue && indexPath.row == 0 {
            // Restaurant (i) tapped
            
            // If we want to add a map, do it here
            
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == Section.Food.rawValue {
            return UITableViewCellEditingStyle.Delete
        } else {
            return UITableViewCellEditingStyle.None
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == Section.Food.rawValue {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let index = indexPath.row
            order.removeFoodItem(index)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chooseDriver" {
            let chooseDriver = segue.destinationViewController as! ChooseDriverTableViewController
            // Pass data to tell which driver should be selected by default
            chooseDriver.delegate = self
            // TODO: Pass the current location
        }
        if segue.identifier == "chooseExpiration" {
            let chooseExpiration = segue.destinationViewController as! ExpiresInViewController
            chooseExpiration.newOrderDelegate = self
            if (order.expiresIn != "") {
                chooseExpiration.selectedTime = order.expiresIn
            }
        }
        if segue.identifier == "chooseLocation" {
            let chooseLocation = segue.destinationViewController as! DeliveryLocationTableViewController
            chooseLocation.delegate = self
            // TODO: Pass the current location
        }
        if segue.identifier == "chooseRestaurant" {
            let chooseRestaurant = segue.destinationViewController as! RestaurantsNewOrderTableViewController
            chooseRestaurant.delegate = self
        }
        if segue.identifier == "editFoodItem" {
            let newFoodItemVC = segue.destinationViewController as! NewFoodItemTableViewController
            let source = sender as? String
            if source == "fromCell" {
                //if user clicks a cell to edit
                newFoodItemVC.foodNameText = self.order.foodItems[(self.tableView.indexPathForSelectedRow?.row)!].name!
                newFoodItemVC.foodDescriptionText = self.order.foodItems[(self.tableView.indexPathForSelectedRow?.row)!].description!
                newFoodItemVC.index = self.tableView.indexPathForSelectedRow?.row
            }
            
            newFoodItemVC.delegate = self
        }
    }
    
    @IBAction func submit(sender: UIButton) {
        sender.enabled = false // Prevents multiple rapid submissions (accidentally?)
        order.create { (success) -> Void in
            if success{
                self.delegate.orderSaved(self)
            }else{
                logError("order failed")
                sender.enabled = true
                //self.delegate.cancelNewOrder(self)
            }
        }
    }
    
}



