//
//  ChooseDriverTableViewController.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/21/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class DriverCell : UITableViewCell{
    @IBOutlet weak var driverName: UILabel!
}

protocol ChooseDriverDelegate {
    func saveDriverToDeliver(chooseDriverVC: ChooseDriverTableViewController)
}

class ChooseDriverTableViewController: UITableViewController {

    let drivers = Drivers()
    
    var chosenDriver: String = ""
    var chosenDriverID: String = ""
    var isAnyDriver: Bool = false
    
    let sectionHeaders = ["", "Choose a driver"]
    var delegate: NewOrderViewController!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    enum Section: Int {
        case AnyDriver = 0
        case ChooseDriver = 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        drivers.clear()
        drivers.restaurant = delegate.order.restaurant.name
        
        activity.hidesWhenStopped = true
        activity.startAnimating()
        
        drivers.getNonDriversFromDB { (success) -> Void in
            if success {
                self.activity.stopAnimating()
                self.tableView.reloadData()
            } else {
                logError("Couldn't get drivers from database")
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
        switch section {
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
            
        default: //shouldn't get here!
            
            let cell: UITableViewCell! = nil
            return cell
            
        }
        
        // (02/21 6:17 PM) In the future, highlight the driver that is already selected.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == Section.AnyDriver.rawValue {
            chosenDriver = "Any driver"
            isAnyDriver = true
            delegate.saveDriverToDeliver(self)
        } else {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                
                let driverName = cell.textLabel!.text!
                chosenDriver = driverName
                let index = indexPath.row

                let availableDriver = drivers.list[index]
                chosenDriverID = availableDriver.objectId!
                delegate.saveDriverToDeliver(self)
            }
        }
    }
    
    func cellForDriversList(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let driverCell = tableView.dequeueReusableCellWithIdentifier("driver", forIndexPath: indexPath) as! DriverCell
        
        let availableDriver = drivers.list[indexPath.row]
        driverCell.driverName.text = availableDriver.username!
        
        return driverCell
    }
    
    override func viewWillDisappear(animated: Bool) {
        delegate.order.deliveredBy = chosenDriver
        delegate.order.deliveredByID = chosenDriverID
        delegate.order.isAnyDriver = isAnyDriver
    }

}
