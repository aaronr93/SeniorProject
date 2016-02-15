//
//  DriverOrdersViewController.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/15/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DriverOrdersViewController: PFQueryTableViewController {
    
    let requestsForMe = ["requestsForMe Order 1", "requestsForMe Order 2", "requestsForMe Order 3", "requestsForMe Order 4", "requestsForMe Order 5"]
    let requestsForAnyone = ["requestsForAnyone Order 1", "requestsForAnyone Order 2", "requestsForAnyone Order 3", "requestsForAnyone Order 4", "requestsForAnyone Order 5"]
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "yourClass"
        
        self.textKey = "yourObject"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Order")
        query.orderByAscending("restaurant")
        
        return query
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
        // #warning Incomplete implementation, return the number of rows
        switch (section) {
        case 0:
            return requestsForMe.count
        case 1:
            return requestsForAnyone.count
        default:
            return 0
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomTableViewCell
        
        // Configure the cell...
        /*let row = indexPath.row
        if indexPath.section == 0 {
            cell.textLabel?.text = requestsForMe[row - 1]
        } else if indexPath.section == 1 {
            cell.textLabel?.text = requestsForAnyone[row - 1]
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator*/
        
        
        cell.restaurant.text = object!["restaurant"] as? String
        
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "driverViewOrderSegue" {
            if let destination = segue.destinationViewController as? BlogViewController {
                if let blogIndex = tableView.indexPathForSelectedRow()?.row {
                    destination.blogName = swiftBlogs[blogIndex]
                }
            }
        }
    }*/
    

}

class CustomTableViewCell: PFTableViewCell {
    
    @IBOutlet weak var restaurant: UILabel!
    @IBOutlet weak var numOrders: UILabel!
    @IBOutlet weak var person: UILabel!
    
}
