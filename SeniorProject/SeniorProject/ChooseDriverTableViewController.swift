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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if drivers.list.count < 1 {
            return 1
        } else {
            return 2
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return drivers.list.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let anyDriverCell = tableView.dequeueReusableCellWithIdentifier("anyDriver", forIndexPath: indexPath)
            return anyDriverCell
        } else if indexPath.section == 1 {
            return cellForDriversList(tableView, indexPath: indexPath)
        } else {
            let cell: UITableViewCell! = nil
            return cell
        }
        
        // (02/21 6:17 PM) In the future, highlight the driver that is already selected.
    }
    
    func cellForDriversList(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let driverCell = tableView.dequeueReusableCellWithIdentifier("driver", forIndexPath: indexPath)
        driverCell.textLabel!.text = drivers.list[indexPath.row]["Driver"]["Username"] as? String
        return driverCell
    }

}
