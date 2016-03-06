//
//  ChooseDriverTableViewController.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/21/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class ChooseDriverTableViewController: UITableViewController {

    let drivers = Drivers()
    var chosenDriver: String = ""
    var chosenRestaurant: String = "Sheetz"
    let sectionHeaders = ["", "Choose a driver"]
    
    enum Section: Int {
        case AnyDriver = 0
        case ChooseDriver = 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        drivers.restaurant = chosenRestaurant
        
        drivers.availableDrivers.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let items = objects {
                    for item in items {
                        self.drivers.add(item)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if drivers.list.count < 1 { //if there are no drivers, don't display the 'choose a driver' section
            return 1
        } else {
            return 2
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.AnyDriver.rawValue: //single static 'Any driver' row
            return 1
        case Section.ChooseDriver.rawValue: //number of drivers available will populate in this 2nd row
            return drivers.list.count
        default: //shouldn't get here
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case Section.AnyDriver.rawValue: //no title for first header--just for looks
            return sectionHeaders[0]
        case Section.ChooseDriver.rawValue: //2nd header title: "choose a driver"
            return sectionHeaders[1]
        default: //shouldn't get here
            return ""
        }
    }
    
    //populates table rows according to driver section semantics
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.AnyDriver.rawValue: //static 'any driver' row
            let anyDriverCell = tableView.dequeueReusableCellWithIdentifier("anyDriver", forIndexPath: indexPath)
            return anyDriverCell
        case Section.ChooseDriver.rawValue: //populate available driver for that row of the section
            return cellForDriversList(tableView, indexPath: indexPath)
        } else { //shouldn't get here!
            let cell: UITableViewCell! = nil
            return cell
        }
        
        // (02/21 6:17 PM) In the future, highlight the driver that is already selected.
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == Section.AnyDriver.rawValue {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                } else if cell.accessoryType == UITableViewCellAccessoryType.None {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    chosenDriver = cell.textLabel!.text!
                    cell.selected = false
                }
            }
        } else if indexPath.section == Section.ChooseDriver.rawValue {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                } else if cell.accessoryType == UITableViewCellAccessoryType.None {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    chosenDriver = cell.textLabel!.text!
                    cell.selected = false
                }
            }
        }
        return indexPath
    }
    
    func cellForDriversList(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let driverCell = tableView.dequeueReusableCellWithIdentifier("driver", forIndexPath: indexPath)
        var cellText = ""
        let list = drivers.list[indexPath.row]
        if let driverAvailability = list["driverAvailability"] as? PFObject {
            if let driver = driverAvailability["driver"] as? PFObject {
                if let name = driver["name"] as? String {
                    cellText = name
                }
            }
        }
        driverCell.textLabel!.text = cellText
        return driverCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chooseDriver" {
            let newOrder = segue.destinationViewController as! NewOrderViewController
            newOrder.order.deliveredBy = chosenDriver
        }
    }

}
