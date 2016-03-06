//
//  RestaurantsNewOrderTableViewController.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/3/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class RestaurantsNewOrderTableViewController: UITableViewController {
    
    var restaurants = [PFObject]()
    var currentCell : Int = 0
    var parent = NewOrderViewController()
    var selectedSomething : Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let getNearbyRestaurants = PFQuery(className:"Restaurant")
        getNearbyRestaurants.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let items = objects {
                    for item in items {
                        self.restaurants.append(item)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.restaurants.count
    }

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        currentCell = indexPath.row
        selectedSomething  = true
        return indexPath
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell", forIndexPath: indexPath) as! RestaurantTableViewCell
        cell.nameLabel.text = restaurants[indexPath.row]["name"] as? String
        cell.distanceLabel.text = "69 mi"
        
        return cell
    }
    
    override func viewWillDisappear(animated: Bool) {
        if(selectedSomething){
            parent.order.restaurantName = restaurants[currentCell]["name"] as! String
        }
        parent.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
        
    }


}