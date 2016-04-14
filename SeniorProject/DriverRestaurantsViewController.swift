//
//  DriverRestaurantsViewController.swift
//  Foodini
//
//  Created by Aaron Rosenberger on 2/19/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

class DriverRestaurantsViewController: UITableViewController, AvailabilityCellDelegate {
    let sectionHeaders = ["Restaurants I'll go to", "When I'm available"]
    let prefs = DriverRestaurantPreferences()
    let POIs = PointsOfInterest()
    let driver = PFUser.currentUser()!
    var timer: NSTimer?
    var isAvailable = false
    var isCurrentlyRefreshing = false
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(DriverRestaurantsViewController.updateRestaurants), forControlEvents: .ValueChanged)
        refreshControl?.beginRefreshing()
        updateRestaurants()
        timer = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self,
                                                       selector: #selector(DriverRestaurantsViewController.updateTimer(_:)),
                                                       userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let expirationCell = tableView.dequeueReusableCellWithIdentifier("expirationTime", forIndexPath: NSIndexPath(forRow: 1, inSection: 0))
        expirationCell.selected = false
        refreshControl?.endRefreshing()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2    // Settings and Restaurants sections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            //'settings' section, which always has two rows (availability expiration and available yes/no)
            return 2
        case 1:
            //'restaurants' section -- number of restaurants available to select from
            return POIs.restaurants.count
        default:
            //shouldn't get here
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            //'Settings'
            return sectionHeaders[1]
        case 1:
            //'Restaurants'
            return sectionHeaders[0]
        default:
            //shouldn't get here
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            //settings data row [ 1) availabilty expiration 2) available yes/no ]
            return cellsForSettings(tableView, cellForRowAtIndexPath: indexPath)
        case 1:
            //respective restaurant in 'restaurants' list
            return cellForRestaurants(tableView, cellForRowAtIndexPath: indexPath)
        default:
            //shouldn't get here!
            let cell: UITableViewCell! = nil
            return cell
        }
    }
    
    func cellForRestaurants(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let restaurantCell = tableView.dequeueReusableCellWithIdentifier("restaurant", forIndexPath: indexPath)
        let row = indexPath.row
        
        if row > POIs.restaurants.count {
            logError("Impossibly, there are more rows than there are restaurants.")
        } else {
            let name = POIs.restaurants[row].name
            if name == "" {
                restaurantCell.textLabel?.text = "Loading..."
                restaurantCell.textLabel?.textColor = UIColor.grayColor()
            } else {
                restaurantCell.textLabel?.text = name
                restaurantCell.textLabel?.textColor = UIColor.blackColor()
            }
            markExistingPreference(restaurantCell)
        }
        
        return restaurantCell
    }
    
    func cellsForSettings(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if row == 0 {
            // "Availability" cell
            let availabilityCell = tableView.dequeueReusableCellWithIdentifier("availability", forIndexPath: indexPath) as! AvailabilityCell
            availabilityCell.cellDelegate = self
            if let selectedExpiration = prefs.selectedExpirationTime {
                if selectedExpiration.isEmpty {
                    availabilityCell.available.enabled = false
                } else {
                    availabilityCell.available.enabled = true
                }
            }
            if !currentlyAvailable(prefs.availability!.expirationDate) {
                prefs.setDriverAvailability(to: false)
            }
            availabilityCell.available.on = prefs.driverAvailability()
            isAvailable = availabilityCell.available.on
            return availabilityCell
        } else if row == 1 {
            // "Expiration time" cell
            let expirationCell = tableView.dequeueReusableCellWithIdentifier("expirationTime", forIndexPath: indexPath)
            if let titleText = expirationCell.textLabel {
                titleText.text = "Expires in"
            }
            if let expirationText = expirationCell.detailTextLabel {
                expirationText.text = prefs.selectedExpirationTime
            }
            
            if !currentlyAvailable(prefs.availability!.expirationDate) {
                // If the timer has ended
                prefs.setDriverAvailability(to: false)
                if let timer = timer {
                    timer.invalidate()
                }
                if let expirationText = expirationCell.detailTextLabel {
                    expirationText.text = prefs.selectedExpirationTime
                }
                // Update the switch
                tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .None)
            }
            
            if prefs.driverAvailability() == true {
                // Driver is available, so the timer should be counting down
                if let expirationText = expirationCell.detailTextLabel {
                    expirationText.text = prefs.getExpirationTime()
                }
            } else {
                // Driver isn't available, so the timer should be reset
                if let expirationText = expirationCell.detailTextLabel {
                    expirationText.text = prefs.selectedExpirationTime
                }
                if let timer = timer {
                    timer.invalidate()
                }
            }
            return expirationCell
        } else {
            let cell: UITableViewCell! = nil
            return cell
        }
    }
    
    func updateTimer(sender: NSTimer) {
        if !isCurrentlyRefreshing {
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .None)
        }
    }
    
    func didChangeSwitchState(sender: AvailabilityCell, isOn: Bool) {
        prefs.setDriverAvailability(to: isOn)
        isAvailable = isOn
        timer = NSTimer.scheduledTimerWithTimeInterval(60.0,
                                                       target: self,
                                                       selector: #selector(DriverRestaurantsViewController.updateTimer(_:)),
                                                       userInfo: nil,
                                                       repeats: true)
        if !isCurrentlyRefreshing {
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .None)
        }
    }
    
    func currentlyAvailable(expirationDate: NSDate) -> Bool {
        let now = NSDate()
        if expirationDate.isFutureDate(now) {
            return true
        } else {
            return false
        }
    }
    
    func updateRestaurants() {
        isCurrentlyRefreshing = true
        activity.startAnimating()
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
                            self.isCurrentlyRefreshing = false
                            dispatch_async(dispatch_get_main_queue()) {
                                self.activity.stopAnimating()
                                self.tableView.reloadData()
                                if let refresh = self.refreshControl {
                                    refresh.endRefreshing()
                                }
                            }
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
    
    func markExistingPreference(cell: UITableViewCell) {
        // Checks the row at the given indexPath for an existing driver preference.
        // If it's previously been marked as unavailable, CHECK it. Otherwise, ignore.
        if let name = cell.textLabel?.text {
            if prefs.isUnavailable(name) {
                cell.accessoryType = UITableViewCellAccessoryType.None
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            // Settings
            if row == 1 {
                // Expiration time
                if !isAvailable {
                    performSegueWithIdentifier("expiresInSegue", sender: self)
                }
                if let expiration = tableView.cellForRowAtIndexPath(indexPath) {
                    expiration.selected = false
                }
            }
            
        } else if section == 1 {
            // Restaurants
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                
                if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
                    
                    // If the cell is checked, uncheck it and mark as Available
                    cell.accessoryType = UITableViewCellAccessoryType.None
                    prefs.markUnavailable(POIs.restaurants[row])
                    
                } else if cell.accessoryType == UITableViewCellAccessoryType.None {
                    
                    // If the cell is unchecked, check it and mark as Unavailable
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    prefs.markAvailable(POIs.restaurants[row])
                    
                }
                
                cell.selected = false
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "expiresInSegue" {
            let dest = segue.destinationViewController as! ExpiresInViewController
            dest.driverRestaurantDelegate = self
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        prefs.saveAll()
    }
    
}

protocol AvailabilityCellDelegate: class {
    func didChangeSwitchState(sender: AvailabilityCell, isOn: Bool)
}

class AvailabilityCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var available: UISwitch!
    weak var cellDelegate: AvailabilityCellDelegate?
    @IBAction func handledSwitchChange(sender: UISwitch) {
        self.cellDelegate?.didChangeSwitchState(self, isOn: sender.on)
    }
}
