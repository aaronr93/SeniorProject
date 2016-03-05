//
//  DriverRestaurantsViewController.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/19/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class AvailabilityCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var available: UISwitch!
}

class DriverRestaurantsViewController: UITableViewController {
    
    let prefs = DriverRestaurantPreferences()
    let sectionHeaders = ["Restaurants", "Settings"]
    
    func getFromParse() {
        let getNearbyRestaurants = PFQuery(className:"Restaurant")
        //itemsForDriverQuery.includeKey("name")
        getNearbyRestaurants.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let items = objects {
                    for item in items {
                        self.prefs.addRestaurant(item)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFromParse()
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
        switch (section) {
        case 0: //'restaurants' section -- number of restaurants available to select from
            return prefs.restaurants.count
        case 1: //'settings' section, which always has two rows (availability expiration and available yes/no)
            return 2
        default: //shouldn't get here
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0: //'Restaurants'
            return sectionHeaders[0]
        case 1: //'Settings'
            return sectionHeaders[1]
        default: //shouldn't get here
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: //respective restaurant in 'restaurants' list
            return cellForRestaurants(tableView, cellForRowAtIndexPath: indexPath)
        case 1: //settings data row ( 1) availabilty expiration 2) available yes/no )
            return cellsForSettings(tableView, cellForRowAtIndexPath: indexPath)
        default: //shouldn't get here!
            let cell: UITableViewCell! = nil
            return cell
        }
    }
    
    func cellForRestaurants(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let restaurantCell = tableView.dequeueReusableCellWithIdentifier("restaurant", forIndexPath: indexPath)
        if indexPath.row > prefs.restaurants.count {
            print("Somehow, there are more rows than there are restaurants.")
        } else {
            restaurantCell.textLabel!.text = prefs.restaurants[indexPath.row]["name"] as? String
        }
        return restaurantCell
    }
    
    func cellsForSettings(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let expirationCell = tableView.dequeueReusableCellWithIdentifier("expirationTime", forIndexPath: indexPath)
            expirationCell.focusStyle = UITableViewCellFocusStyle.Custom
            let exampleTime = "26:42"
            expirationCell.textLabel!.text = "Availability expires in: \(exampleTime)"
            expirationCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            //tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return expirationCell
        } else if indexPath.row == 1 {
            let availabilityCell = tableView.dequeueReusableCellWithIdentifier("availability", forIndexPath: indexPath) as! AvailabilityCell
            availabilityCell.available.selected = prefs.active
            return availabilityCell
        } else {
            let cell: UITableViewCell! = nil
            return cell
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
