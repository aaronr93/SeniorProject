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
    let POIs = PointsOfInterest()
    let driver = PFUser.currentUser()!
    
    var currentLocation = CurrentLocation()
    
    let sectionHeaders = ["Restaurants I won't go to", "When I'm available"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateRestaurants()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateRestaurants()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: //'settings' section, which always has two rows (availability expiration and available yes/no)
            return 2
        case 1: //'restaurants' section -- number of restaurants available to select from
            return POIs.restaurants.count
        default: //shouldn't get here
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: //'Settings'
            return sectionHeaders[1]
        case 1: //'Restaurants'
            return sectionHeaders[0]
        default: //shouldn't get here
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: //settings data row ( 1) availabilty expiration 2) available yes/no )
            return cellsForSettings(tableView, cellForRowAtIndexPath: indexPath)
        case 1: //respective restaurant in 'restaurants' list
            return cellForRestaurants(tableView, cellForRowAtIndexPath: indexPath)
        default: //shouldn't get here!
            let cell: UITableViewCell! = nil
            return cell
        }
    }
    
    func cellForRestaurants(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let restaurantCell = tableView.dequeueReusableCellWithIdentifier("restaurant", forIndexPath: indexPath)
        let row = indexPath.row
        
        if row > POIs.restaurants.count {
            logError("Somehow, there are more rows than there are restaurants.")
        } else {
            let name = POIs.restaurants[row].name
            if name == "" {
                restaurantCell.textLabel?.text = "Loading..."
                restaurantCell.textLabel?.textColor = UIColor.grayColor()
            } else {
                restaurantCell.textLabel?.text = name
                restaurantCell.textLabel?.textColor = UIColor.blackColor()
                markExistingPreference(indexPath)
            }
        }
        
        return restaurantCell
    }
    
    func cellsForSettings(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if row == 0 {     // "Availability" cell
            
            let availabilityCell = tableView.dequeueReusableCellWithIdentifier("availability", forIndexPath: indexPath) as! AvailabilityCell
            availabilityCell.available.selected = currentlyAvailable(prefs.availability!.expirationDate)
            return availabilityCell
            
        } else if row == 1 {  // "Expiration time" cell
            
            let expirationCell = tableView.dequeueReusableCellWithIdentifier("expirationTime", forIndexPath: indexPath)
            expirationCell.textLabel!.text! = "Expires In"
            let time = prefs.getExpirationTime()
            expirationCell.detailTextLabel!.text! = time
            return expirationCell
            
        } else {
            
            let cell: UITableViewCell! = nil
            return cell
            
        }
    }
    
    func currentlyAvailable(expirationDate: NSDate) -> Bool {
        let now = NSDate()
        if expirationDate.isFutureDate(now) {
            return true
        } else {
            return false
        }
    }
    
    func updateRestaurants() {
        POIs.searchFor("Food", aroundLocation: currentLocation) { result in
            if result {
                // Success
                self.tableView.reloadData()
            } else {
                // Some kind of error occurred while trying to
                // find nearby locations.
                logError("Couldn't find searched locations")
            }
        }
    }
    
    func markExistingPreference(indexPath: NSIndexPath) {
        // Checks the row at the given indexPath for an existing driver preference.
        // If it's previously been marked as unavailable, CHECK it. Otherwise, ignore.
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if let name = cell?.textLabel?.text {
            let restaurant = Restaurant(name: name)
            if prefs.isUnavailable(restaurant) {
                cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            // Settings
            if row == 1 {
                // Expiration time
                performSegueWithIdentifier("expiresInSegue", sender: self)
            }
            
        } else if section == 1 {
            // Restaurants
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                
                if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
                    
                    // If the cell is checked, uncheck it and mark as Available
                    cell.accessoryType = UITableViewCellAccessoryType.None
                    prefs.markAvailable(POIs.restaurants[row])
                    
                } else if cell.accessoryType == UITableViewCellAccessoryType.None {
                    
                    // If the cell is unchecked, check it and mark as Unavailable
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    prefs.markUnavailable(POIs.restaurants[row])
                    
                }
                
                cell.selected = false
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "expiresInSegue" {
            let dest = segue.destinationViewController as! ExpiresInViewController
            dest.driverRestaurantDelegate = self
            if !currentlyAvailable(prefs.availability!.expirationDate) {
                // If the Expires In field is NOT counting down
                dest.selectedTime = "1 hour"
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        prefs.saveAll()
    }
    
}
