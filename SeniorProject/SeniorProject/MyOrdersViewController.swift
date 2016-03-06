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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get orders sent by the user
        let ordersISentQuery = PFQuery(className:"Order")
        ordersISentQuery.includeKey("restaurant")
        ordersISentQuery.includeKey("driverToDeliver")
        ordersISentQuery.whereKey("OrderingUser", equalTo: PFUser.currentUser()!)
        ordersISentQuery.whereKey("OrderState", notEqualTo: "Completed")
        
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
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        //get orders received by the user
        let ordersIReceivedQuery = PFQuery(className:"Order")
        ordersIReceivedQuery.includeKey("restaurant")
        ordersIReceivedQuery.includeKey("OrderingUser")
        ordersIReceivedQuery.whereKey("driverToDeliver", equalTo: PFUser.currentUser()!)
        ordersIReceivedQuery.whereKey("OrderState", notEqualTo: "Completed")
        
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
                print("Error: \(error!) \(error!.userInfo)")
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
                cell.recipient?.text = "Not Accepted"
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
        dest.order.restaurantName  = ordersIReceived[index]["restaurant"]["name"] as! String
        dest.order.orderID  = ordersIReceived[index].objectId!
        dest.order.deliverTo = ordersIReceived[index]["OrderingUser"]["username"] as! String
        let locationString: String = (ordersIReceived[index]["DeliveryAddress"] as! String) + " " + (ordersIReceived[index]["DeliveryCity"] as! String) + ", " + (ordersIReceived[index]["DeliveryState"] as! String) + " " + (ordersIReceived[index]["DeliveryZip"] as! String)
        dest.order.location = locationString
        dest.order.expiresIn = ParseDate.timeLeft(ordersIReceived[index]["expirationDate"] as! NSDate)
    }
    
    func passOrdersISentInfo(index: Int, dest: MyOrderTableViewController) {
        let order = ordersISent[index]
        
        dest.order.restaurantName  = order["restaurant"]["name"] as! String
        dest.order.orderID  = order.objectId!
        if (order["driverToDeliver"] != nil) {
            dest.order.deliverTo = order["driverToDeliver"]["username"] as! String
        } else {
            dest.order.deliverTo = "Not Accepted"
        }
        
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
            print("Order Status N/A")
        }
        
        let locationString: String = (order["DeliveryAddress"] as! String) + " " + (order["DeliveryCity"] as! String) + ", " + (order["DeliveryState"] as! String) + " " + (order["DeliveryZip"] as! String)
        dest.order.location = locationString
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
            NSLog("shouldn't ever be here")
        }
    }

    
    func makeSentenceCase(inout str: String) {
        if(str != ""){str.replaceRange(str.startIndex...str.startIndex, with: String(str[str.startIndex]).capitalizedString)}
    }

   
}
