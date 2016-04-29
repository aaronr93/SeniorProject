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
    var selectIndex: NSIndexPath?
    let dest = CustomerDestinations()
    let user = PFUser.currentUser()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let backButton = navigationItem.backBarButtonItem {
            backButton.title = "Order"
        }
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
                if let refresh = self.refreshControl {
                    refresh.endRefreshing()
                }
                self.tableView.reloadData()
            } else {
                NSLog("Error fetching destination items from parse")
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
            
            let index = indexPath.row
            let item = dest.history[index].name
            
            if let label = historyCell.textLabel {
                label.text = item
            }
            
            if let dest = destination {
                if dest.name == item {
                    // This is the one we previously selected. Check it.
                    historyCell.accessoryType = .Checkmark
                }
            }
            
            return historyCell
            
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 1 {
            return .Delete
        } else {
            return .None
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && editingStyle == .Delete {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                if let label = cell.textLabel {
                    if let destination = label.text {
                        dest.remove(destination) { success in
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectIndex = indexPath
        if indexPath.section == 1 { // History of delivery locations
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                if let label = cell.textLabel {
                    if label.text != "No results found" {
                        let index = indexPath.row
                        destination = dest.history[index]
                        delegate.saveDeliveryLocation(self)
                    }
                }
            }
        } else {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                cell.selected = false
            }
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: // Custom delivery location
            return "Custom"
        default: // History of delivery locations
            return "History"
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

}
