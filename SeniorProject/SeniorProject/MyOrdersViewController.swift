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
    var ordersISent = [PFObject]()
    var ordersIReceived = [PFObject]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get orders sent by the user
        let ordersISentQuery = PFQuery(className:"Order")
        ordersISentQuery.includeKey("restaurant")
        ordersISentQuery.includeKey("driverToDeliver")
        ordersISentQuery.includeKey("destination")
        ordersISentQuery.whereKey("OrderingUser", equalTo: PFUser.currentUser()!)
        ordersISentQuery.whereKey("OrderState", notEqualTo: "Delivered")
        ordersISentQuery.whereKey("OrderState", notEqualTo: "Deleted")
        
        ordersISentQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let orders = objects {
                    for order in orders {
                        self.ordersISent.append(order)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                logError("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        //get orders received by the user
        let ordersIReceivedQuery = PFQuery(className:"Order")
        ordersIReceivedQuery.includeKey("restaurant")
        ordersIReceivedQuery.includeKey("OrderingUser")
        ordersIReceivedQuery.includeKey("destination")
        ordersIReceivedQuery.whereKey("driverToDeliver", equalTo: PFUser.currentUser()!)
        ordersIReceivedQuery.whereKey("OrderState", notEqualTo: "Delivered")
        ordersIReceivedQuery.whereKey("OrderState", notEqualTo: "Available")
        ordersIReceivedQuery.whereKey("OrderState", notEqualTo: "Deleted")
        
        ordersIReceivedQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let orders = objects {
                    for order in orders {
                        self.ordersIReceived.append(order)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                logError("Error: \(error!) \(error!.userInfo)")
            }
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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
        var order : PFObject?
        if indexPath.section == 0 {
            order = ordersISent[indexPath.row]
        } else if indexPath.section == 1 {
            order = ordersIReceived[indexPath.row]
        }
        
        var restaurantName: String = order!["restaurant"]["name"] as! String
        
        restaurantName.makeFirstLetterInStringUpperCase()
    
        cell.restaurant?.text = restaurantName
        if indexPath.section == 0 {
            if (order!["driverToDeliver"] != nil){
                cell.recipient?.text = order!["driverToDeliver"]["username"] as? String
            } else {
                cell.recipient?.text = "Any driver"
            }
            
        } else {
            if (order!["OrderingUser"] != nil){
                cell.recipient?.text = order!["OrderingUser"]["username"] as? String
            } else {
                cell.recipient?.text = "Error"
            }
            
        }
        return cell
    }
    
    func passOrdersIReceivedInfo(index: Int, dest: GetThatOrderTableViewController) {
        let order = ordersIReceived[index]
        dest.order.restaurantName  = order["restaurant"]["name"] as! String
        dest.order.orderID  = order.objectId!
        dest.order.deliverTo = order["OrderingUser"]["username"] as! String
        dest.order.deliverToID = order["OrderingUser"].objectId!!
        dest.order.isAnyDriver = order["isAnyDriver"] as! Bool
        
        if let destination = order["destination"] as? PFObject {
            if let destName = destination["name"] as? String {
                if !destName.isEmpty {
                    dest.order.location = destName
                } else {
                    dest.order.location = ""
                }
            }
        }
        dest.order.expiresIn = ParseDate.timeLeft(order["expirationDate"] as! NSDate)
        
        let orderStatus = order["OrderState"] as! String
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
            logError("OrderState is N/A")
        }
    }
    
    func passOrdersISentInfo(index: Int, dest: MyOrderTableViewController) {
        let order = ordersISent[index]
        
        if let restaurant = order["restaurant"] as? PFObject {
            if let name = restaurant["name"] as? String {
                dest.order.restaurantName = name
            }
        }
        dest.order.orderID  = order.objectId!
        if (order["driverToDeliver"] != nil) {
            if let driverToDeliver = order["driverToDeliver"] as? PFObject {
                if let username = driverToDeliver["username"] as? String {
                    dest.order.deliveredBy = username
                }
            }
        } else {
            dest.order.deliveredBy = "Any driver"
        }
        dest.order.isAnyDriver = order["isAnyDriver"] as! Bool
        
        if let orderStatus = order["OrderState"] as? String {
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
                logError("OrderState is N/A")
            }
        }
        
        if let destination = order["destination"] as? PFObject {
            if let destName = destination["name"] as? String {
                if !destName.isEmpty {
                    dest.order.location = destName
                } else {
                    dest.order.location = ""
                }
            }
        }
        dest.order.expiresIn = ParseDate.timeLeft(order["expirationDate"] as! NSDate)
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
                 if tableView.indexPathForSelectedRow?.section == 0{
                    if let ordersISentIndex = tableView.indexPathForSelectedRow?.row {
                        passOrdersISentInfo(ordersISentIndex, dest: destination)
                    }
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section){
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
