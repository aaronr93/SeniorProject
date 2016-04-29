//
//  DriverOrdersViewController.swift
//  Foodini
//
//  Created by Aaron Rosenberger on 2/15/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class OrderCell: UITableViewCell {
    @IBOutlet weak var restaurant: UILabel!
    @IBOutlet weak var recipient: UILabel!
}

class DriverOrdersViewController: UITableViewController {
    
    var sectionHeaders = ["Requests For Me", "Requests For Anyone"]
    var driverOrders = [PFOrder]()
    var anyDriverOrders = [PFOrder]()
    
    enum sectionTypes: Int {
        case driverOrders = 0
        case anyDriverOrders = 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case sectionTypes.driverOrders.rawValue:
            return driverOrders.count //count of 'requests for me' items
        case sectionTypes.anyDriverOrders.rawValue:
            return anyDriverOrders.count //count of 'quests for anyone' items
        default: //shouldn't get here
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case sectionTypes.driverOrders.rawValue:
            if driverOrders.count == 0 {
                return "No requests for me"
            } else {
                return sectionHeaders[0] //'requests for me'
            }
        case sectionTypes.anyDriverOrders.rawValue:
            if anyDriverOrders.count == 0 {
                return "No requests for anyone"
            } else {
                return sectionHeaders[1] //'requests for anyone'
            }
        default: //shouldn't get here
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("order", forIndexPath: indexPath) as! OrderCell
        let row = indexPath.row
        var order = PFOrder()
        
        if indexPath.section == sectionTypes.driverOrders.rawValue {
            order = driverOrders[row]
        } else if indexPath.section == sectionTypes.anyDriverOrders.rawValue {
            order = anyDriverOrders[row]
        }
        
        let restaurantName = order.restaurantName
        
        var userName: String = "Any driver"
        if let user = order.OrderingUser as? PFUser {
            if let userNameText = user.username {
                userName = userNameText
            }
        }
        
        cell.restaurant?.text = restaurantName
        cell.recipient?.text = userName
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        navigationItem.backBarButtonItem?.title = ""
        if segue.identifier == "getThatOrderSegue" {
            if let destination = segue.destinationViewController as? GetThatOrderTableViewController {
                if tableView.indexPathForSelectedRow?.section == 0 {
                    if let driverOrdersIndex = tableView.indexPathForSelectedRow?.row {
                        passDriverOrdersInfo(driverOrdersIndex, dest: destination)
                    }
                } else if tableView.indexPathForSelectedRow?.section == 1 {
                    if let anyDriverOrdersIndex = tableView.indexPathForSelectedRow?.row {
                        passAnyOrdersInfo(anyDriverOrdersIndex, dest: destination)
                    }
                }
                destination.driverDelegate = self
            }
        }
    }
    
    func passDriverOrdersInfo(index: Int, dest: GetThatOrderTableViewController) {
        let order = driverOrders[index]
        
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
                NSLog("Order Status N/A")
        }
    }
    
    func passAnyOrdersInfo(index: Int, dest: GetThatOrderTableViewController) {
        let order = anyDriverOrders[index]
        
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
            case "PaidFor":
                dest.order.orderState = OrderState.PaidFor
            case "Delivered":
                dest.order.orderState = OrderState.Delivered
            case "Completed":
                dest.order.orderState = OrderState.Completed
            case "Deleted":
                dest.order.orderState = OrderState.Deleted
            default:
                NSLog("Order Status N/A")
        }
    }
    
    override func viewDidLoad() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(DriverOrdersViewController.update), forControlEvents: .ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        refreshControl?.beginRefreshing()
        update()
    }
    
    func update() {
        clear(listOfOrders: &driverOrders)
        getOrdersForMe() { result in
            if result {
                self.clear(listOfOrders: &self.anyDriverOrders)
                self.getOrdersForAnyone() { result in
                    if result {
                        if let refresh = self.refreshControl {
                            refresh.endRefreshing()
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    func clear(inout listOfOrders list: [PFOrder]) {
        list.removeAll()
    }
    
    func getOrdersForMe(completion: (success: Bool) -> Void) {
        let query = PFQuery(className: PFOrder.parseClassName())
        let user = PFUser.currentUser()!
        let now = NSDate()
        
        query.includeKey("OrderingUser")
        query.includeKey("destination")
        query.whereKey("driverToDeliver", equalTo: user)
        query.whereKey("OrderingUser", notEqualTo: user)
        query.whereKey("OrderState", equalTo: "Available")
        query.whereKey("expirationDate", greaterThan: now)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let orders = objects {
                    for order in orders {
                        let order = order as! PFOrder
                        self.driverOrders.append(order)
                    }
                    completion(success: true)
                }
            } else {
                NSLog("\(error!.userInfo)")
                completion(success: false)
            }
        }
    }
    
    func getOrdersForAnyone(completion: (success: Bool) -> Void) {
        let query = PFQuery(className: PFOrder.parseClassName())
        let user = PFUser.currentUser()!
        let now = NSDate()
        
        query.includeKey("OrderingUser")
        query.includeKey("destination")
        query.whereKey("isAnyDriver", equalTo: true)
        query.whereKey("OrderState", equalTo: "Available")
        query.whereKey("expirationDate", greaterThan: now)
        query.whereKey("OrderingUser", notEqualTo: user)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let orders = objects {
                    for order in orders {
                        let order = order as! PFOrder
                        if (order.driverToDeliver == nil) {
                            self.anyDriverOrders.append(order)
                        }
                    }
                    completion(success: true)
                }
            } else {
                NSLog("\(error!.userInfo)")
                completion(success: false)
            }
        }
    }
}
