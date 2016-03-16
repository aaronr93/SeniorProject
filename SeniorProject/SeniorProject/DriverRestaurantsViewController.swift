//
//  DriverRestaurantsViewController.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/19/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class AvailabilityCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var available: UISwitch!
}

class DriverRestaurantsViewController: UITableViewController, CLLocationManagerDelegate {
    
    let prefs = DriverRestaurantPreferences()
    let sectionHeaders = ["Restaurants I'll go to", "When I'm available"]
    let user = PFUser.currentUser()!
    var nearbyRestaurants = [PFObject]()
    let driver = PFUser.currentUser()!
    
    let defaultMileage = 15.0
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var location : CLLocationCoordinate2D?
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        //update their location in the database
        let point = PFGeoPoint(latitude:locValue.latitude, longitude:locValue.longitude)
        user["locationCoord"] = point
        user.saveInBackground()
        
        self.updateRestaurants()
        
        
        //TODO: load any driver requests by distance
    }
    
    func getRestaurantsByDistance(userGeoPoint: PFGeoPoint){
        // Create a query for places
        let query = PFQuery(className:"Restaurant")
        // Interested in locations near user.
        query.whereKey("locationCoord", nearGeoPoint:userGeoPoint, withinMiles:defaultMileage)
        // Limit what could be a lot of points.
        query.limit = 20
        // Final list of objects
        _ = query.findObjectsInBackgroundWithBlock { (restaurantObjects, error) -> Void in
            if error == nil{
                if let restaurants = restaurantObjects{
                    self.nearbyRestaurants = restaurants
                    self.tableView.reloadData()
                }else{
                    self.tableView.reloadData()
                    logError("No closeby restaurants")
                }
            }else{
                logError("error getting closeby restaurants")
            }
        }
    }
    
    func updateRestaurants(){
        if let userGeoPoint = user["locationCoord"] as? PFGeoPoint{
                getRestaurantsByDistance(userGeoPoint)
        }else{
            logError("no user location")
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let addressString : String = "89-30 70th road Forest Hills, NY"
        
        self.geocoder.geocodeAddressString(addressString, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if error != nil {
                logError("Geocode failed with error: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
                let placemark = placemarks![0]
                self.location = placemark.location?.coordinate
                //TODO: load any driver requests by last recorded distance
                
            }
        })
    }
    
    func getFromParse() {
        let getNearbyRestaurants = PFQuery(className:"Restaurant")
        
        //itemsForDriverQuery.includeKey("name")
        getNearbyRestaurants.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let items = objects {
                    for item in items {
                        self.prefs.addRestaurant(item)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                logError("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getFromParse()
    }
    
    func findDriversLocation(){
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //accurate active location
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
            
        }else{
            //need to use last location in table since we cannot use location services
            
            let addressString : String = "89-30 70th road Forest Hills, NY"
            self.geocoder.geocodeAddressString(addressString, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if error != nil {
                    logError("Geocode failed with error: \(error!.localizedDescription)")
                } else if placemarks!.count > 0 {
                    self.updateRestaurants()
                    //TODO: load any driver requests by last recorded or inputted distance
                    
                }
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        findDriversLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: //'restaurants' section -- number of restaurants available to select from
            return nearbyRestaurants.count
        case 1: //'settings' section, which always has two rows (availability expiration and available yes/no)
            return 2
        default: //shouldn't get here
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0: //'Restaurants'
            return sectionHeaders[0]
        case 1: //'Settings'
            return sectionHeaders[1]
        default: //shouldn't get here
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: //respective restaurant in 'restaurants' list
            return cellForRestaurants(tableView, cellForRowAtIndexPath: indexPath)
        case 1: //settings data row ( 1) availabilty expiration 2) available yes/no )
            return cellsForSettings(tableView, cellForRowAtIndexPath: indexPath)
        default: //shouldn't get here!
            let cell: UITableViewCell! = nil
            return cell
        }
    }
    
    func cellForRestaurants(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let restaurantCell = tableView.dequeueReusableCellWithIdentifier("restaurant", forIndexPath: indexPath)
        if indexPath.row > nearbyRestaurants.count {
            logError("Somehow, there are more rows than there are restaurants.")
        } else {
            restaurantCell.textLabel!.text = nearbyRestaurants[indexPath.row]["name"] as? String
        }
        return restaurantCell
    }
    
    func cellsForSettings(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {     // "Expiration time" cell
            
            let expirationCell = tableView.dequeueReusableCellWithIdentifier("expirationTime", forIndexPath: indexPath)
            expirationCell.textLabel!.text! = "Expires In"
            let time = prefs.expirationTime
            expirationCell.detailTextLabel!.text! = time
            return expirationCell
            
        } else if indexPath.row == 1 {  // "Availability" cell
            
            let availabilityCell = tableView.dequeueReusableCellWithIdentifier("availability", forIndexPath: indexPath) as! AvailabilityCell
            availabilityCell.available.selected = prefs.active
            return availabilityCell
            
        } else {
            
            let cell: UITableViewCell! = nil
            return cell
            
        }
    }
    
    func addRestaurantPreference(restaurant: PFObject, completion: (success: Bool) -> Void){
        let driverAvailableRestaurant = PFObject(className: "DriverAvailableRestaurants")
        
        driverAvailableRestaurant["restaurant"] = restaurant
        
        let driverAvailablityQuery = PFQuery(className: "DriverAvailability")
        
        driverAvailablityQuery.whereKey("driver", equalTo: driver)
        
        driverAvailablityQuery.findObjectsInBackgroundWithBlock { (driverAvailabilityObjects, error) -> Void in
            if error == nil{
                if let driverAvailablities = driverAvailabilityObjects{
                    if !driverAvailablities.isEmpty{
                        driverAvailableRestaurant["driverAvailability"] = driverAvailablities.first!
                        driverAvailableRestaurant.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if error == nil && success{
                                completion(success: true)
                            }else{
                                logError("Error: Saving driver available restaurant")
                                completion(success: false)
                            }
                        })
                        
                    }else{
                        logError("Error: No driver availabilities!")
                        completion(success: false)
                    }
                }
            }else{
                logError("Error: Error querying driver availibility")
                completion(success: false)
            }
        }
    }
    
    func deleteRestaurantPreference(restaurant: PFObject, completion: (success: Bool) -> Void){
        
        let driverAvailablityQuery = PFQuery(className: "DriverAvailability")
        
        driverAvailablityQuery.whereKey("driver", equalTo: driver)
        
        driverAvailablityQuery.findObjectsInBackgroundWithBlock { (driverAvailabilityObjects, error) -> Void in
            if error == nil{
                if let driverAvailablities = driverAvailabilityObjects{
                    if !driverAvailablities.isEmpty{
                        let driverAvailableRestaurantQuery = PFQuery(className: "DriverAvailableRestaurants")
                        driverAvailableRestaurantQuery.whereKey("driverAvailability", equalTo: driverAvailablities.first!)
                        driverAvailableRestaurantQuery.whereKey("restaurant", equalTo: restaurant)
                        
                        driverAvailableRestaurantQuery.findObjectsInBackgroundWithBlock({ (driverAvailableRestaurantsObjects, errorDriverAvailableRestaurant) -> Void in
                            if errorDriverAvailableRestaurant == nil{
                                if let driverAvailableRestaurants = driverAvailableRestaurantsObjects{
                                    if !driverAvailableRestaurants.isEmpty{
                                        driverAvailableRestaurants.first!.deleteInBackgroundWithBlock({ (deleteSuccess, deleteError) -> Void in
                                            if deleteError == nil && deleteSuccess{
                                                completion(success: true)
                                            }else{
                                                logError("Error: Saving driver available restaurant")
                                                completion(success: false)
                                            }
                                        })
                                    }else{
                                        logError("Error: Query yielded no results")
                                        completion(success: false)
                                    }
                                }
                            }
                        })
                    }else{
                        logError("Error: No driver availabilities!")
                        completion(success: false)
                    }
                }
            }else{
                logError("Error: Error querying driver availibility")
                completion(success: false)
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.section == 0 {
            // Restaurants
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
                    deleteRestaurantPreference(nearbyRestaurants[indexPath.row], completion: { (success) -> Void in
                        if success{
                            cell.accessoryType = UITableViewCellAccessoryType.None
                        }else{
                            logError("error deleting restaurant preference")
                        }
                        
                    })
                } else if cell.accessoryType == UITableViewCellAccessoryType.None {
                    addRestaurantPreference(nearbyRestaurants[indexPath.row], completion: { (success) -> Void in
                        if success{
                            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                        }else{
                            logError("error adding restaurant preference")
                        }
                        
                    })
                }
                cell.selected = false
            }
        } else if indexPath.section == 1 {
            // Settings
            if indexPath.row == 0 {
                // Expiration time
                performSegueWithIdentifier("expiresInSegue", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "expiresInSegue" {
            let dest = segue.destinationViewController as! ExpiresInViewController
            dest.driverRestaurantDelegate = self
            if prefs.expirationTime != "" {
                dest.selectedTime = prefs.expirationTime
            }
        }
    }
    
}
