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
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return ordersISent.count
        case 1:
            return ordersIReceived.count
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
            order = ordersISent[indexPath.row]
        } else if indexPath.section == 1 {
            order = ordersIReceived[indexPath.row]
        }
        
        var restaurantName: String = order!["restaurant"]["name"] as! String
        makeSentenceCase(&restaurantName)
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
    
    func makeSentenceCase(inout str: String) {
        str.replaceRange(str.startIndex...str.startIndex, with: String(str[str.startIndex]).capitalizedString)
    }

   
}
