//
//  ChooseDriverTableViewController.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/21/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

protocol ChooseDriverDelegate {
    func returnFromSubScreen(chooseDriver: ChooseDriverTableViewController)
}

class ChooseDriverTableViewController: UITableViewController {
    
    var delegate: ChooseDriverDelegate!
    let drivers = Drivers()
    //var chosenDriver = PFObject()
    var chosenDriver: String = ""
    let sectionHeaders = ["", "Choose a driver"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        drivers.itemsForDriverQuery.findObjectsInBackgroundWithBlock {
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
        case 0: //single static 'Any driver' row
            return 1
        case 1: //number of drivers available will populate in this 2nd row
            return drivers.list.count
        default: //shouldn't get here
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0: //no title for first header--just for looks
            return sectionHeaders[0]
        case 1: //2nd header title: "choose a driver"
            return sectionHeaders[1]
        default: //shouldn't get here
            return ""
        }
    }
    
    //populates table rows according to driver section semantics
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: //static 'any driver' row
            let anyDriverCell = tableView.dequeueReusableCellWithIdentifier("anyDriver", forIndexPath: indexPath)
            return anyDriverCell
        case 1: //populate available driver for that row of the section
            return cellForDriversList(tableView, indexPath: indexPath)
        default: //shouldn't get here!
            let cell: UITableViewCell! = nil
            return cell
        }
        
        // (02/21 6:17 PM) In the future, highlight the driver that is already selected.
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 0 {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                } else if cell.accessoryType == UITableViewCellAccessoryType.None {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    chosenDriver = cell.textLabel!.text!
                    cell.selected = false
                }
            }
        } else if indexPath.section == 1 {
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
        driverCell.textLabel!.text = drivers.list[indexPath.row].objectId! as String
        // not sure what to do here ^
        return driverCell
    }

}
