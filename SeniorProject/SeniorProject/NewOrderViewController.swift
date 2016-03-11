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
    var deliverySectionTitles = ["Delivered by", "Location", "Expires In"]
    let order = Order()
    var current = NSIndexPath()
    
    enum Section: Int {
        case Restaurant = 0
        case Food = 1
        case Settings = 2
    }
    
    func cancelNewItem(newFoodItemVC: NewFoodItemViewController){
        newFoodItemVC.navigationController?.popViewControllerAnimated(true)
    }
    
    func editNewItem(newFoodItemVC: NewFoodItemViewController) {
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
    func saveNewItem(newFoodItemVC: NewFoodItemViewController){
        let foodItem = Food(name: newFoodItemVC.foodNameText, description: newFoodItemVC.foodDescriptionText)
        order.addFoodItem(foodItem)
        self.tableView.reloadData()
        newFoodItemVC.navigationController?.popViewControllerAnimated(true)
    }
    
    // Delegate method for Choose Driver
    func saveDriverToDeliver(chooseDriverVC: ChooseDriverTableViewController) {
        self.order.deliveredByID = chooseDriverVC.chosenDriverID
        self.tableView.reloadData()
        chooseDriverVC.navigationController?.popViewControllerAnimated(true)
    }
    
    // Delegate mehtod for Choose Restaurant
    func saveRestaurant(restaurantsNewOrderVC: RestaurantsNewOrderTableViewController) {
        self.tableView.reloadData()
        restaurantsNewOrderVC.navigationController?.popViewControllerAnimated(true)
    }
    
    // Delegate method for Choose Delivery Location
    func saveDeliveryLocation(deliveryLocationVC: DeliveryLocationTableViewController) {
        self.tableView.reloadData()
        order.destinationID = deliveryLocationVC.destinationID
        print(order.destinationID)
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
        case Section.Restaurant.rawValue: // single, static "select a restaurant" cell (for now)
            return 1
        case Section.Food.rawValue: //based on number of food items in order
            return order.foodItems.count
        case Section.Settings.rawValue: // 3 -- 'delivered by', 'location', and 'expires in'
            return deliverySectionTitles.count
        default: //shouldn't get here
            return 0
        }
    }
    
    //populates New Order screen headers
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case Section.Restaurant.rawValue: //"Restaurant" header
            return sectionHeaders[0]
        case Section.Food.rawValue: //"Food items" header
            return sectionHeaders[1]
        case Section.Settings.rawValue: //"Delivery" header
            return sectionHeaders[2]
        default: //shouldn't get here
            return ""
        }
    }
    
    //populates different custom cell types based on the table section
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.Restaurant.rawValue: //static "select a restaurant" cell (for now)
            return cellForRestaurantSection(tableView, cellForRowAtIndexPath: indexPath)
        case Section.Food.rawValue: //2nd section has the food info
            return cellForFoodSection(tableView, cellForRowAtIndexPath: indexPath)
        case Section.Settings.rawValue: //3rd section has delivery info
            return cellForDeliverySection(tableView, cellForRowAtIndexPath: indexPath)
        default: //shouldn't get here!
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
  
        foodCell.foodItem.text = order.foodItems[indexPath.row].name!
        foodCell.foodDescription.text = order.foodItems[indexPath.row].description!
        
        return foodCell
    }
    
    func cellForDeliverySection(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let deliveryCell = tableView.dequeueReusableCellWithIdentifier("newDeliveryCell", forIndexPath: indexPath)
       
        deliveryCell.textLabel!.text! = deliverySectionTitles[indexPath.row]
        deliveryCell.detailTextLabel!.text! = getTextFor(indexPath.row)
        
        return deliveryCell
    }
    
    //populate row data for the Delivery section. (Value names show what each row is)
    func getTextFor(row: Int) -> String {
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
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == Section.Food.rawValue {//only the 'Food items' section needs this (section '1' zero-indexed)
            let headerFrame: CGRect = tableView.frame
            
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
        performSegueWithIdentifier("editFoodItem", sender: "fromPlus")
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
            chooseDriver.delegate = self
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
        }
        if segue.identifier == "chooseRestaurant" {
            let chooseRestaurant = segue.destinationViewController as! RestaurantsNewOrderTableViewController
            chooseRestaurant.delegate = self
        }
        if segue.identifier == "editFoodItem" {
            let newFoodItemVC = segue.destinationViewController as! NewFoodItemViewController
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
        order.create { (success) -> Void in
            if success{
                print("order successful")
                self.delegate.cancelNewOrder(self)
            }else{
                print("order failed")
            }
        }
    }
    
}



