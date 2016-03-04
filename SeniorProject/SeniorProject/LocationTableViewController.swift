//
//  LocationTableViewController.swift
//  SeniorProject
//
//  Created by Seth Loew on 3/4/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class LocationTableViewController: UITableViewController {

    var locations = ["MAP", "HAL", "MEP", "Hopeman", "Memorial"]
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
