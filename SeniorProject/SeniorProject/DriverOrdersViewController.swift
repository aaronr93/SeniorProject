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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
        
        
        return cell
    }
    
    override func viewDidLoad() {
        PFCloud.callFunctionInBackground("getOrdersForDriver", withParameters: ["user": "xrZ4ryBR8I"])
            {
            (jsonOrders, error) in
            if error == nil {
                for order in (jsonOrders as? [PFObject])!{
                    /*let thisOrderObj = Order()
                    let orderingUser = order.objectForKey("OrderingUser") as! PFUser
                    let restaurant = order.objectForKey("restaurant") as! PFObject
                    let restaurantName = restaurant.objectForKey("name") as! String
                    thisOrderObj.restaurant?.name = restaurantName
                    thisOrderObj.OrderingUser = orderingUser*/
                    self.driverOrders += [order]
                }
                print(self.driverOrders)
                
            }
        }
    }
}
