//
//  RestaurantsNewOrderTableViewController.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/3/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

protocol RestaurantsNewOrderDelegate {
    func saveRestaurant(restaurantsNewOrderVC: RestaurantsNewOrderTableViewController)
}

class RestaurantsNewOrderTableViewController: UITableViewController {
    
    var restaurants = [PFObject]()
    var currentCell : Int = 0
    var delegate : NewOrderViewController!
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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentCell = indexPath.row
        selectedSomething  = true
        delegate.saveRestaurant(self)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell", forIndexPath: indexPath) as! RestaurantTableViewCell
        cell.nameLabel.text = restaurants[indexPath.row]["name"] as? String
        cell.distanceLabel.text = "6.9 mi"
        
        return cell
    }
    
    override func viewWillDisappear(animated: Bool) {
        if selectedSomething {
            delegate.order.restaurantId = restaurants[currentCell].objectId!
            delegate.order.restaurantName = restaurants[currentCell]["name"] as! String
        }
        delegate.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
        
    }


}
