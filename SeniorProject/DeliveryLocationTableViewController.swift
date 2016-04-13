//
//  DeliveryLocationTableViewController.swift
//  Foodini
//
//  Created by Aaron Rosenberger on 3/7/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

protocol DeliveryLocationDelegate {
    func saveDeliveryLocation(deliveryLocationVC: DeliveryLocationTableViewController)
}

class DeliveryLocationTableViewController: UITableViewController, CustomDeliveryLocationDelegate {
    
    var destination: Destination?
    var delegate: NewOrderViewController!
    var selectIndex = NSIndexPath()
    let dest = CustomerDestinations()
    let user = PFUser.currentUser()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(DeliveryLocationTableViewController.getDestinations), forControlEvents: .ValueChanged)
        refreshControl?.beginRefreshing()
        destination = delegate.order.destination
        getDestinations()
    }
    
    func getDestinations() {
        dest.getDestinationItemsFromParse() { result in
            if result {
                // Order successfully delivered
                self.tableView.reloadData()
                if let refresh = self.refreshControl {
                    refresh.endRefreshing()
                }
            } else {
                logError("Error fetching destination items from parse")
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            // Custom delivery location
            return 1
        case 1:
            // History of delivery locations
            return dest.history.count
        default:
            // Shouldn't get here
            // TODO: Default "no results" cell
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // Custom delivery location
            
            let customCell = tableView.dequeueReusableCellWithIdentifier("custom", forIndexPath: indexPath) as! CustomDeliveryLocationTableViewCell
            customCell.delegate = self
            return customCell
            
        default: // History of delivery locations
            
            let historyCell = tableView.dequeueReusableCellWithIdentifier("history", forIndexPath: indexPath)
            selectIndex = indexPath
            
            if dest.history.count == 0 {
                // If there are no items in the user's destination history
                historyCell.textLabel!.text! = "No results found"
                historyCell.detailTextLabel!.text! = ""
            } else if dest.history.count > 0 {
                let index = indexPath.row
                let item = dest.history[index].name
                
                if let textLabel = historyCell.textLabel {
                    textLabel.text = item
                }
                
                if let dest = destination {
                    if dest.name == item {
                        // This is the one we previously selected. Check it.
                        historyCell.accessoryType = .Checkmark
                    }
                }
            }
            
            return historyCell
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 { // History of delivery locations
            let index = indexPath.row
            destination = dest.history[index]
        }
        delegate.saveDeliveryLocation(self)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: // Custom delivery location
            return "Custom"
        default: // History of delivery locations
            return "History"
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let cell = tableView.cellForRowAtIndexPath(selectIndex) as! CustomDeliveryLocationTableViewCell
        let customValue = cell.customField!.text!
        
        for item in dest.history {
            if item.loc == nil {
                // Location for a destination is optional, but we prefer to check for
                //   duplicates based on location. So if it isn't set, just check if
                //   the names are the same. This encourages setting the location.
                if customValue == item.name {
                    logError("Destination already exists")
                    return false
                }
            } else {
                // The location has (hopefully) been set. Make sure there isn't another destination
                //   already in the database that's near this one.
                /*  CURRENTLY UNSUPPORTED
                TODO: Add a custom map where you can drop a pin for custom destination
                if item.loc?.isNear(thisPoint: customPoint, within: 0.1) {
                logError("Destination already exists, or you're picking a location too specific")
                return
                }*/
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if selectIndex.section == 0 {
            // Custom destination
            
            let cell = tableView.cellForRowAtIndexPath(selectIndex) as! CustomDeliveryLocationTableViewCell
            let customValue = cell.customField!.text!
            
            if customValue != "" {
                dest.addDestinationItemToDB(customValue) { result in
                    if result {
                        
                    } else {
                        logError("Error adding destination item to DB")
                    }
                }
            }
        } else if selectIndex.section == 1 {
            // History of destinations
            delegate.order.destination = destination
        }
        
        delegate.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 2)], withRowAnimation: .Automatic)
    }

}
