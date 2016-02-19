//
//  DriverRestaurantsViewController.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/19/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit

class DriverRestaurantsViewController: UITableViewController {
    
    let prefs = DriverRestaurantPreferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prefs.getFromParse()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
            return prefs.restaurants.count
        case 1:
            return 2
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("restaurant", forIndexPath: indexPath)

        // Configure the cell...
        if indexPath.section == 0 {
            // Restaurants
            if indexPath.row > prefs.restaurants.count {
                print("Somehow, there are more rows than there are restaurants.")
            } else {
                cell.textLabel!.text = prefs.restaurants[indexPath.row]
            }
        } else if indexPath.section == 1 {
            // Settings
            cell.focusStyle = UITableViewCellFocusStyle.Custom
            if indexPath.row == 0 {
                cell.textLabel!.text = "Expires in"
            } else if indexPath.row == 1 {
                cell.textLabel!.text = "Available to pick up food"
            }
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        if section == 0 {
            return "Restaurants"
        } else if section == 1 {
            return "Settings"
        } else {
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.section == 0 {
            // Restaurants
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                } else if cell.accessoryType == UITableViewCellAccessoryType.None {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
                cell.selected = false
            }
        } else if indexPath.section == 1 {
            // Settings
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                cell.selected = false
            }
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
