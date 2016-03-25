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
    
    let POIs = PointsOfInterest()
    var currentCell: Int = 0
    var delegate: NewOrderViewController!
    var selectedSomething: Bool = false
    
    var currentLocation = CurrentLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        addLocalPOIs(withQueryString: "Food")
    }
    
    func addLocalPOIs(withQueryString item: String) {
        // Search for nearby locations related to the argument for `searchFor`
        POIs.clear()
        POIs.searchFor(item, aroundLocation: currentLocation) { result in
            if result {
                // Success
                self.tableView.reloadData()
            } else {
                // Some kind of error occurred while trying to
                // find nearby locations.
                logError("Couldn't find searched locations")
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return POIs.restaurants.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentCell = indexPath.row
        selectedSomething = true
        delegate.saveRestaurant(self)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell", forIndexPath: indexPath)
        let index = indexPath.row
        
        let name = POIs.restaurants[index].name
        let dist = POIs.restaurants[index].dist
        
        if name == "" {
            cell.textLabel?.text = "Loading..."
            cell.textLabel?.textColor = UIColor.grayColor()
        } else {
            cell.textLabel?.text = name
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.detailTextLabel?.text = String(format: "%.1f", dist!) + " mi"
        }
        return cell
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if selectedSomething {
            delegate.order.restaurant = POIs.restaurants[currentCell]
            delegate.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
        }
    }
    
}
