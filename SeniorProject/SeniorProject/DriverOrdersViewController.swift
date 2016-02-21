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

class DriverOrdersViewController: UITableViewController
{

    var sectionHeaders = ["Requests For Me","Requests For Anyone"]
    
    var driverOrders = [PFObject]()
    var anyDriverOrders = [PFObject]()
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return driverOrders.count
        case 1:
            return anyDriverOrders.count
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
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("order", forIndexPath: indexPath) as! OrderCell
        var order : PFObject?
        if indexPath.section == 0{
            order = driverOrders[indexPath.row]
        }else if indexPath.section == 1{
            order = anyDriverOrders[indexPath.row]
        }
    
        var rName : String = order!["restaurant"]["name"] as! String
        rName.replaceRange(rName.startIndex...rName.startIndex, with: String(rName[rName.startIndex]).capitalizedString)
        cell.restaurant?.text = rName
        
        
        
        cell.recipient?.text = order!["OrderingUser"]["username"] as? String
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        navigationItem.backBarButtonItem?.title = ""
        if segue.identifier == "getThatOrderSegue" {
            if let destination = segue.destinationViewController as? GetThatOrderTableViewController {
                if tableView.indexPathForSelectedRow?.section == 0{
                    if let driverOrdersIndex = tableView.indexPathForSelectedRow?.row {
                        destination.restaurantName  = driverOrders[driverOrdersIndex]["restaurant"]["name"] as! String
                        destination.orderID  = driverOrders[driverOrdersIndex].objectId!
                        destination.deliveryTo = driverOrders[driverOrdersIndex]["OrderingUser"]["username"] as! String
                        let locationString : String = (driverOrders[driverOrdersIndex]["DeliveryAddress"] as! String) + " " + (driverOrders[driverOrdersIndex]["DeliveryCity"] as! String) + ", " + (driverOrders[driverOrdersIndex]["DeliveryState"] as! String) + " " + (driverOrders[driverOrdersIndex]["DeliveryZip"] as! String)
                        destination.location = locationString
                        destination.expiresIn = "33:46"//driverOrders[driverOrdersIndex]["expirationDate"] as! NSDate
                    }
                }else if tableView.indexPathForSelectedRow?.section == 1{
                    if let anyDriverOrdersIndex = tableView.indexPathForSelectedRow?.row {
                        destination.restaurantName  = anyDriverOrders[anyDriverOrdersIndex]["restaurant"]["name"] as! String
                    }
                }
            }
        }
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
