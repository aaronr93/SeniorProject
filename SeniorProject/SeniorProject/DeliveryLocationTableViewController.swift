//
//  DeliveryLocationTableViewController.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 3/7/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit

protocol DeliveryLocationDelegate {
    func saveDeliveryLocation(deliveryLocationVC: DeliveryLocationTableViewController)
}

class DeliveryLocationTableViewController: UITableViewController, CustomDeliveryLocationDelegate {
    
    var deliveryLocation: String = ""
    var destinationID: String = ""
    var delegate: NewOrderViewController!
    var selectIndex = NSIndexPath()
    let dest = CustomerDestinations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deliveryLocation = delegate.order.location
        
        dest.getDestinationItemsFromParse() {
            result in
            if result {
                // Order successfully delivered
                self.tableView.reloadData()
            } else {
                logError("Error fetching destination items from parse")
            }
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // Custom delivery location
            return 1
        case 1: // History of delivery locations
            return dest.history.count
        default: // Shouldn't get here
            return 1    // Default "no results" cell
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
                historyCell.textLabel!.text! = dest.history[index].name!
                historyCell.detailTextLabel!.text! = "69 mi"
            }
            
            return historyCell
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 { // History of delivery locations
            let index = indexPath.row
            deliveryLocation = dest.history[index].name!
            destinationID = dest.history[index].id!
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
    
    override func viewWillDisappear(animated: Bool) {
        if selectIndex.section == 0 {
            let cell = tableView.cellForRowAtIndexPath(selectIndex) as! CustomDeliveryLocationTableViewCell
            let customValue = cell.customField!.text!
            delegate.order.location = customValue
            
            // Add the newly typed item to the database for later use
            let destItem = Destination(name: customValue, id: nil)
            for destI in (dest.history) {
                if destI.name == destI.name {
                    logError("Destination already exists")
                    return
                }
            }
            if destItem.name != "" {
                dest.addDestinationItemToDB(destItem, completion: { (success, id) in
                    if success{
                        destItem.id = id
                        self.delegate.order.destinationID = id!
                    }else{
                        logError("error adding destination item to DB")
                    }
                })
            }
            
        } else {
            delegate.order.location = deliveryLocation
            delegate.order.destinationID = destinationID
        }
        delegate.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 2)], withRowAnimation: .Automatic)
    }

}
