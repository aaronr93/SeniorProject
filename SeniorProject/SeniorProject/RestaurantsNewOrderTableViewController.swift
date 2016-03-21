//
//  RestaurantsNewOrderTableViewController.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/3/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
import MapKit

protocol RestaurantsNewOrderDelegate {
    func saveRestaurant(restaurantsNewOrderVC: RestaurantsNewOrderTableViewController)
}

class RestaurantsNewOrderTableViewController: UITableViewController {
    
    var restaurants = [PFObject]()
    var currentCell: Int = 0
    var delegate: NewOrderViewController!
    var selectedSomething : Bool = false
    let myLocation = CurrentLocation().getCurrentLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        getNearbyRestaurants() { result in
            if result {
                self.restaurants.sortInPlace({ (a: PFObject, b: PFObject) -> Bool in
                    return (a["locationCoord"] as! PFGeoPoint).latitude < (b["locationCoord"] as! PFGeoPoint).latitude &&
                        (a["locationCoord"] as! PFGeoPoint).longitude < (b["locationCoord"] as! PFGeoPoint).longitude
                })
                self.tableView.reloadData()
            }
        }
    }
    
    func getNearbyRestaurants(completion: (success: Bool) -> Void) {
        let getNearbyRestaurants = PFQuery(className: "Restaurant")
        getNearbyRestaurants.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let items = objects {
                    for item in items {
                        self.restaurants.append(item)
                    }
                    completion(success: true)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completion(success: false)
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentCell = indexPath.row
        selectedSomething  = true
        delegate.saveRestaurant(self)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell", forIndexPath: indexPath)
        cell.textLabel!.text = restaurants[indexPath.row]["name"] as? String
        
        var distance: Double
        let parseLoc = restaurants[indexPath.row]["locationCoord"] as! PFGeoPoint
        let restaurantLoc = CLLocation(latitude: parseLoc.latitude, longitude: parseLoc.longitude)
        print(restaurantLoc)
        distance = myLocation.distanceFromLocation(restaurantLoc) * 0.000621371192
        let distanceStr = String(format: "%.1f", distance)
        
        cell.detailTextLabel!.text = "\(distanceStr) mi"
        
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
