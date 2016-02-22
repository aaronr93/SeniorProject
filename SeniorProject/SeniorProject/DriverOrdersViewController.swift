//
//  DriverOrdersViewController.swift
//  SeniorProject
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
    var driverOrders = [PFObject]()
    var anyDriverOrders = [PFObject]()
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return driverOrders.count
        case 1:
            return anyDriverOrders.count
        default:
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return sectionHeaders[0]
        case 1:
            return sectionHeaders[1]
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("order", forIndexPath: indexPath) as! OrderCell
        var order : PFObject?
        if indexPath.section == 0 {
            order = driverOrders[indexPath.row]
        } else if indexPath.section == 1 {
            order = anyDriverOrders[indexPath.row]
        }
    
        var restaurantName: String = order!["restaurant"]["name"] as! String
        makeSentenceCase(&restaurantName)
        cell.restaurant?.text = restaurantName

        cell.recipient?.text = order!["OrderingUser"]["username"] as? String
        return cell
    }
    
    func makeSentenceCase(inout str: String) {
        str.replaceRange(str.startIndex...str.startIndex, with: String(str[str.startIndex]).capitalizedString)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        navigationItem.backBarButtonItem?.title = ""
        if segue.identifier == "getThatOrderSegue" {
            if let destination = segue.destinationViewController as? GetThatOrderTableViewController {
                if tableView.indexPathForSelectedRow?.section == 0{
                    if let driverOrdersIndex = tableView.indexPathForSelectedRow?.row {
                        passDriverOrdersInfo(driverOrdersIndex, dest: destination)
                    }
                } else if tableView.indexPathForSelectedRow?.section == 1{
                    if let anyDriverOrdersIndex = tableView.indexPathForSelectedRow?.row {
                        passAnyOrdersInfo(anyDriverOrdersIndex, dest: destination)
                    }
                }
            }
        }
    }
    
    func passDriverOrdersInfo(index: Int, dest: GetThatOrderTableViewController) {
        dest.order.restaurantName  = driverOrders[index]["restaurant"]["name"] as! String
        dest.order.orderID  = driverOrders[index].objectId!
        dest.order.deliverTo = driverOrders[index]["OrderingUser"]["username"] as! String
        let locationString: String = (driverOrders[index]["DeliveryAddress"] as! String) + " " + (driverOrders[index]["DeliveryCity"] as! String) + ", " + (driverOrders[index]["DeliveryState"] as! String) + " " + (driverOrders[index]["DeliveryZip"] as! String)
        dest.order.location = locationString
        dest.order.expiresIn = ParseDate.timeLeft(driverOrders[index]["expirationDate"] as! NSDate)
    }
    
    func passAnyOrdersInfo(index: Int, dest: GetThatOrderTableViewController) {
        dest.order.restaurantName  = anyDriverOrders[index]["restaurant"]["name"] as! String
        dest.order.orderID  = anyDriverOrders[index].objectId!
        dest.order.deliverTo = anyDriverOrders[index]["OrderingUser"]["username"] as! String
        let locationString: String = (anyDriverOrders[index]["DeliveryAddress"] as! String) + " " + (anyDriverOrders[index]["DeliveryCity"] as! String) + ", " + (anyDriverOrders[index]["DeliveryState"] as! String) + " " + (anyDriverOrders[index]["DeliveryZip"] as! String)
        dest.order.location = locationString
        dest.order.expiresIn = ParseDate.timeLeft(anyDriverOrders[index]["expirationDate"] as! NSDate)
    }
    
    override func viewDidLoad() {
        //get orders sent to the driver
        let ordersForDriverQuery = PFQuery(className:"Order")
        ordersForDriverQuery.includeKey("restaurant")
        ordersForDriverQuery.includeKey("OrderingUser")
        ordersForDriverQuery.whereKey("driverToDeliver", equalTo: PFUser.currentUser()!)
    
        ordersForDriverQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let orders = objects {
                    for order in orders {
                        self.driverOrders.append(order)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        //get any driver available orders
        
        let ordersForAnyDriverQuery = PFQuery(className:"Order")
        ordersForAnyDriverQuery.includeKey("restaurant")
        ordersForAnyDriverQuery.includeKey("OrderingUser")
        ordersForAnyDriverQuery.whereKey("isAnyDriver", equalTo: true)
        
        ordersForAnyDriverQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let orders = objects {
                    for order in orders {
                        if (order["driverToDeliver"] == nil){
                            self.anyDriverOrders.append(order)
                        }
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
