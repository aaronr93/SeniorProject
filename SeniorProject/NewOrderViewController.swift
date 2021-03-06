//
//  NewOrderViewController.swift
//  Foodini
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
    var sectionHeaders = ["Restaurant", "Food", "Delivery"]
    var deliverySectionTitles = ["Delivered by", "Location", "Expires in"]
    var deliverySectionPrompts = ["Select a driver...", "Select delivery location...", "Select expiration time..."]
    var delegate: NewOrderViewDelegate!
    let order = Order()
    var current = NSIndexPath()
    let user = PFUser.currentUser()!
    
    enum Section: Int {
        case Restaurant = 0
        case Food = 1
        case Settings = 2
    }
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        submitButton.setTitleColor(UIColor.grayColor(), forState: .Disabled)
        submitButton.enabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if order.restaurant.name.isEmpty || order.foodItems.isEmpty || order.deliveredBy.isEmpty ||
            order.destination.name.isEmpty || order.expiresIn.isEmpty {
            // User hasn't filled out Restaurant, Food, or Delivered By
            submitButton.enabled = false
        } else {
            submitButton.enabled = true
        }
    }

    func cancelNewItem(newFoodItemVC: NewFoodItemTableViewController) {
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
        tableView.reloadData()
        newFoodItemVC.navigationController?.popViewControllerAnimated(true)
    }
    
    // Delegate method for New Food Item
    func saveNewItem(newFoodItemVC: NewFoodItemTableViewController){
        let foodItem = Food(name: newFoodItemVC.foodNameText, description: newFoodItemVC.foodDescriptionText)
        order.addFoodItem(foodItem)
        tableView.reloadData()
        newFoodItemVC.navigationController?.popViewControllerAnimated(true)
    }
    
    // Delegate method for Choose Driver
    func saveDriverToDeliver(chooseDriverVC: ChooseDriverTableViewController) {
        order.deliveredByID = chooseDriverVC.chosenDriverID
        order.deliveredBy = chooseDriverVC.chosenDriver
        order.isAnyDriver = chooseDriverVC.isAnyDriver
        tableView.reloadData()
        chooseDriverVC.navigationController?.popViewControllerAnimated(true)
    }
    
    // Delegate method for Choose Restaurant
    func saveRestaurant(restaurantsNewOrderVC: RestaurantsNewOrderTableViewController) {
        tableView.reloadData()
        restaurantsNewOrderVC.navigationController?.popViewControllerAnimated(true)
    }
    
    // Delegate method for Choose Delivery Location
    func saveDeliveryLocation(deliveryLocationVC: DeliveryLocationTableViewController) {
        tableView.reloadData()
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
        switch section {
            case Section.Restaurant.rawValue:
                // single, static "select a restaurant" cell (for now)
                return 1
            case Section.Food.rawValue:
                //based on number of food items in order
                return 1 + order.foodItems.count
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
                if indexPath.row == order.foodItems.count {
                    let cell = tableView.dequeueReusableCellWithIdentifier("addNewFoodItem", forIndexPath: indexPath)
                    cell.textLabel?.textColor = UIColor.grayColor()
                    return cell
                } else {
                    return cellForFoodSection(tableView, cellForRowAtIndexPath: indexPath)
                }
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

        if restaurantName == "Select restaurant..." {
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
            case Section.Food.rawValue:
                if indexPath.row == order.foodItems.count {
                    return 44
                } else {
                    return 60
                }
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
            if indexPath.row == order.foodItems.count {
                performSegueWithIdentifier("editFoodItem", sender: "new")
            } else {
                performSegueWithIdentifier("editFoodItem", sender: "existing")
            }
            break
        case Section.Settings.rawValue:
            switch indexPath.row {
            case 0:
                // Driver field
                if(order.restaurant.name != "Select restaurant...") {//have to choose a restaurant before a driver
                //since driver display logic is dependent upon restaurant chosen (due to blacklists)
                    performSegueWithIdentifier("chooseDriver", sender: self)
                }
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
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        if indexPath.section == Section.Restaurant.rawValue && indexPath.row == 0 {
            // Restaurant (i) tapped
            
            // If we want to add a map, do it here
            
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == Section.Food.rawValue && //don't enable the 'delete' button for 'add new food item'
            (indexPath.row != tableView.numberOfRowsInSection(indexPath.section)-1) {
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
            chooseDriver.drivers.restaurant = self.order.restaurant.name
            chooseDriver.delegate = self
        }
        if segue.identifier == "chooseExpiration" {
            let chooseExpiration = segue.destinationViewController as! ExpiresInViewController
            chooseExpiration.newOrderDelegate = self
            chooseExpiration.selectedHours = self.order.expiresHours
            chooseExpiration.selectedMinutes = self.order.expiresMinutes
        }
        if segue.identifier == "chooseLocation" {
            let chooseLocation = segue.destinationViewController as! DeliveryLocationTableViewController
            chooseLocation.delegate = self
        }
        if segue.identifier == "chooseRestaurant" {
            let chooseRestaurant = segue.destinationViewController as! RestaurantsNewOrderTableViewController
            chooseRestaurant.delegate = self
        }
        if segue.identifier == "editFoodItem" {
            let newFoodItemVC = segue.destinationViewController as! NewFoodItemTableViewController
            let source = sender as? String
            if source == "existing" {
                //if user clicks a cell to edit
                newFoodItemVC.foodNameText = self.order.foodItems[(self.tableView.indexPathForSelectedRow?.row)!].name!
                newFoodItemVC.foodDescriptionText = self.order.foodItems[(self.tableView.indexPathForSelectedRow?.row)!].description!
                newFoodItemVC.index = self.tableView.indexPathForSelectedRow?.row
            }
            newFoodItemVC.delegate = self
        }
    }
    
    @IBAction func submit(sender: UIButton) {
        sender.enabled = false // Prevents multiple rapid submissions
        order.create { success in
            if success {
                self.delegate.orderSaved(self)
            } else {
                sender.enabled = true
            }
        }
    }
    
}



