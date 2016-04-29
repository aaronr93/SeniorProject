//
//  RestaurantsNewOrderTableViewController.swift
//  Foodini
//
//  Created by Zach Nafziger on 3/3/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

protocol RestaurantsNewOrderDelegate {
    func saveRestaurant(restaurantsNewOrderVC: RestaurantsNewOrderTableViewController)
}

class RestaurantsNewOrderTableViewController: UITableViewController {
    
    let POIs = PointsOfInterest()
    var currentCell: Int = 0
    var delegate: NewOrderViewController!
    var selectedSomething: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(RestaurantsNewOrderTableViewController.addLocalPOIs), forControlEvents: .ValueChanged)
        addLocalPOIs()
    }
    
    func addLocalPOIs() {
        // Search for nearby locations related to the argument for `searchFor`
        refreshControl?.beginRefreshing()
        PFGeoPoint.geoPointForCurrentLocationInBackground { (loc: PFGeoPoint?, error: NSError?) in
            if error == nil {
                // Found current location
                if let loc = loc {
                    let location = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
                    let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                    let region = MKCoordinateRegion(center: location.coordinate, span: span)
                    self.POIs.clear()
                    self.POIs.searchFor("Food", inRegion: region, withLocation: location) { result in
                        if result {
                            // Success
                            if let refresh = self.refreshControl {
                                refresh.endRefreshing()
                            }
                            self.tableView.reloadData()
                        } else {
                            // Some kind of error occurred while trying to
                            // find nearby locations.
                            logError("Couldn't find searched locations")
                        }
                    }
                }
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
