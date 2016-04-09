//
//  MyOrdersViewController.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 2/22/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class MyOrdersViewController: UITableViewController {
    
    let sectionHeaders = ["Requests I've Sent", "Requests I'm Picking Up"]
    var ordersISent = [PFOrder]()
    var ordersIReceived = [PFOrder]()
    let user = PFUser.currentUser()!
    var current: NSIndexPath?
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.hidesWhenStopped = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        clear(listOfOrders: &ordersISent)
        getOrdersISent() { result in
            if result { self.tableView.reloadData() }
        }
        
        clear(listOfOrders: &ordersIReceived)
        getOrdersIReceived() { result in
            if result { self.tableView.reloadData() }
        }
    }
    
    func clear(inout listOfOrders list: [PFOrder]) {
        list.removeAll()
    }
    
    func refresh(listOfOrders list: [PFOrder]) {
        PFOrder.fetchAllIfNeededInBackground(list) { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.tableView.reloadData()
            } else {
                logError("Couldn't refresh orders.")
            }
        }
    }
    
    func getOrdersISent(completion: (success: Bool) -> Void) {
        let query = PFQuery(className: PFOrder.parseClassName())
        let user = PFUser.currentUser()!
        let now = NSDate()
        
        query.includeKey("driverToDeliver")
        query.includeKey("destination")
        query.whereKey("OrderState", notContainedIn: ["Completed", "Deleted"])
        query.whereKey("OrderingUser", equalTo: user)
        query.whereKey("expirationDate", greaterThan: now)
        
        activity.startAnimating()
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let orders = objects {
                    for order in orders {
                        let order = order as! PFOrder
                        self.ordersISent.append(order)
                    }
                    self.activity.stopAnimating()
                    completion(success: true)
                }
            } else {
                logError("\(error!.userInfo)")
                completion(success: false)
            }
        }
    }
    
    func getOrdersIReceived(completion: (success: Bool) -> Void) {
        let query = PFQuery(className: PFOrder.parseClassName())
        let user = PFUser.currentUser()!
        let now = NSDate()
        
        query.includeKey("OrderingUser")
        query.includeKey("destination")
        query.whereKey("driverToDeliver", equalTo: user)
        query.whereKey("OrderState", notContainedIn: ["Completed", "Available", "Deleted"])
        query.whereKey("expirationDate", greaterThan: now)
        query.whereKey("OrderingUser", notEqualTo: user)
        
        activity.startAnimating()
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let orders = objects {
                    for order in orders {
                        let order = order as! PFOrder
                        if (order.driverToDeliver != nil) {
                            self.ordersIReceived.append(order)
                        }
                    }
                    self.activity.stopAnimating()
                    completion(success: true)
                }
            } else {
                logError("\(error!.userInfo)")
                completion(success: false)
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2 //"requests I've sent" and "requests I'm picking up"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: //section 1--number of "requests I've sent"
            return ordersISent.count
        case 1: //section 2--number of "requests I'm picking up"
            return ordersIReceived.count
        default: //shouldn't get here
            return 0
        }

    }
    
    //hard-coded section header names (in string array above)
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: //"Requests I've Sent"
            return sectionHeaders[0]
        case 1: //"Requests I'm Picking Up"
            return sectionHeaders[1]
        default: //shouldn't get here
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("order", forIndexPath: indexPath) as! OrderCell
        let row = indexPath.row
        let section = indexPath.section
        var order = PFOrder()
        
        if indexPath.section == 0 {
            order = ordersISent[row]
        } else if indexPath.section == 1 {
            order = ordersIReceived[row]
        }
        
        let restaurantName = order.restaurantName
        
        var username = "Not Available"
        if section == 0 {
            if let user = order.driverToDeliver as? PFUser {
                if let usernameText = user.username {
                    username = usernameText
                }
            }
            
        } else if section == 1 {
            if let user = order.OrderingUser as? PFUser {
                if let usernameText = user.username {
                    username = usernameText
                }
            }
        }
        
        cell.restaurant?.text = restaurantName
        cell.recipient?.text = username
        
        return cell
    }
    
    func passOrdersIReceivedInfo(index: Int, dest: GetThatOrderTableViewController) {
        activity.startAnimating()
        
        let order = ordersIReceived[index]
        
        let restaurant = Restaurant(name: order.restaurantName)
        restaurant.loc = order.restaurantLoc
        dest.order.restaurant = restaurant
        
        dest.order.orderID  = order.objectId!
        dest.order.expiresIn = ParseDate.timeLeft(order.expirationDate)
        
        let orderingUser = order.OrderingUser as! PFUser
        dest.order.deliverTo = orderingUser.username!
        dest.order.deliverToID = orderingUser.objectId!

        dest.order.isAnyDriver = order.isAnyDriver
        
        let destination = order.destination as! PFDestination
        let name = destination.name
        let id = destination.objectId!
        let loc = destination.destination
        let toPass = Destination(name: name, id: id)
        toPass.loc = loc
        dest.order.destination = toPass
        
        let orderStatus = order.OrderState
        switch orderStatus {
            case "Available":
                dest.order.orderState = OrderState.Available
            case "Acquired":
                dest.order.orderState = OrderState.Acquired
            case "Deleted":
                dest.order.orderState = OrderState.Deleted
            case "PaidFor":
                dest.order.orderState = OrderState.PaidFor
            case "Delivered":
                dest.order.orderState = OrderState.Delivered
            case "Completed":
                dest.order.orderState = OrderState.Completed
            default:
                logError("Order Status N/A")
        }
        
        activity.stopAnimating()
    }
    
    func passOrdersISentInfo(index: Int, dest: MyOrderTableViewController) {
        activity.startAnimating()
        
        let order = ordersISent[index]
        
        let restaurant = Restaurant(name: order.restaurantName)
        restaurant.loc = order.restaurantLoc
        dest.order.restaurant = restaurant
        
        dest.order.orderID  = order.objectId!
        dest.order.expiresIn = ParseDate.timeLeft(order.expirationDate)
        dest.index = current
        
        if let driverToDeliver = order.driverToDeliver as? PFUser{
            dest.order.deliveredBy = driverToDeliver.username!
            dest.order.deliveredByID = driverToDeliver.objectId!
        }else{
            dest.order.deliveredBy = "Any Driver"
            dest.order.deliveredByID = ""

        }
        
        
        dest.order.isAnyDriver = order.isAnyDriver
        
        let destination = order.destination as! PFDestination
        let name = destination.name
        let id = destination.objectId!
        let loc = destination.destination
        let toPass = Destination(name: name, id: id)
        toPass.loc = loc
        dest.order.destination = toPass
        
        let orderStatus = order.OrderState
        switch orderStatus {
            case "Available":
                dest.order.orderState = OrderState.Available
            case "Acquired":
                dest.order.orderState = OrderState.Acquired
            case "PaidFor":
                dest.order.orderState = OrderState.PaidFor
            case "Delivered":
                dest.order.orderState = OrderState.Delivered
            case "Completed":
                dest.order.orderState = OrderState.Completed
            case "Deleted":
                dest.order.orderState = OrderState.Deleted
            default:
                logError("Order Status N/A")
        }
        
        activity.stopAnimating()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        navigationItem.backBarButtonItem?.title = ""
        if segue.identifier == "getThatOrderSegue" {
            if let destination = segue.destinationViewController as? GetThatOrderTableViewController {
                if tableView.indexPathForSelectedRow?.section == 1{
                    if let ordersIReceivedIndex = tableView.indexPathForSelectedRow?.row {
                        passOrdersIReceivedInfo(ordersIReceivedIndex, dest: destination)
                    }
                }
            }
        } else if segue.identifier == "myOrderSegue" {
            if let destination = segue.destinationViewController as? MyOrderTableViewController {
                destination.delegate = self
                if tableView.indexPathForSelectedRow?.section == 0 {
                    if let ordersISentIndex = tableView.indexPathForSelectedRow?.row {
                        passOrdersISentInfo(ordersISentIndex, dest: destination)
                    }
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        current = indexPath
        switch (indexPath.section) {
        case 0: //row in prior personal orders section
            performSegueWithIdentifier("myOrderSegue", sender: self)
        case 1: //row in potential customer orders section
            performSegueWithIdentifier("getThatOrderSegue", sender: self)
        default: //code error!
            NSLog("BAD SHIT: Performing unidentified segue")
        }
    }

    
    func makeSentenceCase(inout str: String) {
        if(str != ""){str.replaceRange(str.startIndex...str.startIndex, with: String(str[str.startIndex]).capitalizedString)}
    }

   
}
