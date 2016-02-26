//
//  DriverOrdersViewController.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/15/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class OrderCell: UITableViewCell {
    @IBOutlet weak var restaurant: UILabel!
    @IBOutlet weak var recipient: UILabel!
}

class DriverOrdersViewController: UITableViewController, CLLocationManagerDelegate {
    
    var sectionHeaders = ["Requests For Me", "Requests For Anyone"]
    var driverOrders = [PFObject]()
    var anyDriverOrders = [PFObject]()
    
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var location : CLLocationCoordinate2D?
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return driverOrders.count
        case 1:
            return anyDriverOrders.count
        default:
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return sectionHeaders[0]
        case 1:
            return sectionHeaders[1]
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("order", forIndexPath: indexPath) as! OrderCell
        var order : PFObject?
        if indexPath.section == 0 {
            order = driverOrders[indexPath.row]
        } else if indexPath.section == 1 {
            order = anyDriverOrders[indexPath.row]
        }
    
        var restaurantName: String = order!["restaurant"]["name"] as! String
        
        restaurantName.makeFirstLetterInStringUpperCase()
        
        cell.restaurant?.text = restaurantName
        cell.recipient?.text = order!["OrderingUser"]["username"] as? String
        return cell
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        navigationItem.backBarButtonItem?.title = ""
        if segue.identifier == "getThatOrderSegue" {
            if let destination = segue.destinationViewController as? GetThatOrderTableViewController {
                if tableView.indexPathForSelectedRow?.section == 0{
                    if let driverOrdersIndex = tableView.indexPathForSelectedRow?.row {
                        passDriverOrdersInfo(driverOrdersIndex, dest: destination)
                    }
                } else if tableView.indexPathForSelectedRow?.section == 1{
                    if let anyDriverOrdersIndex = tableView.indexPathForSelectedRow?.row {
                        passAnyOrdersInfo(anyDriverOrdersIndex, dest: destination)
                    }
                }
            }
        }
    }
    
    func passDriverOrdersInfo(index: Int, dest: GetThatOrderTableViewController) {
        dest.order.restaurantName  = driverOrders[index]["restaurant"]["name"] as! String
        dest.order.orderID  = driverOrders[index].objectId!
        dest.order.deliverTo = driverOrders[index]["OrderingUser"]["username"] as! String
        let locationString: String = (driverOrders[index]["DeliveryAddress"] as! String) + " " + (driverOrders[index]["DeliveryCity"] as! String) + ", " + (driverOrders[index]["DeliveryState"] as! String) + " " + (driverOrders[index]["DeliveryZip"] as! String)
        dest.order.location = locationString
        dest.order.expiresIn = ParseDate.timeLeft(driverOrders[index]["expirationDate"] as! NSDate)
    }
    
    func passAnyOrdersInfo(index: Int, dest: GetThatOrderTableViewController) {
        dest.order.restaurantName  = anyDriverOrders[index]["restaurant"]["name"] as! String
        dest.order.orderID  = anyDriverOrders[index].objectId!
        dest.order.deliverTo = anyDriverOrders[index]["OrderingUser"]["username"] as! String
        let locationString: String = (anyDriverOrders[index]["DeliveryAddress"] as! String) + " " + (anyDriverOrders[index]["DeliveryCity"] as! String) + ", " + (anyDriverOrders[index]["DeliveryState"] as! String) + " " + (anyDriverOrders[index]["DeliveryZip"] as! String)
        dest.order.location = locationString
        dest.order.expiresIn = ParseDate.timeLeft(anyDriverOrders[index]["expirationDate"] as! NSDate)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        //TODO: load any driver requests by distance
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let addressString : String = "89-30 70th road Forest Hills, NY"
        
        
        self.geocoder.geocodeAddressString(addressString, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if error != nil {
                print("Geocode failed with error: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
                let placemark = placemarks![0]
                self.location = placemark.location?.coordinate
                print(self.location)
                //TODO: load any driver requests by last recorded distance
                
            }
        })
    }
    
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
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
                    print("Geocode failed with error: \(error!.localizedDescription)")
                } else if placemarks!.count > 0 {
                    let placemark = placemarks![0]
                    self.location = placemark.location?.coordinate
                    print(self.location)
                    //TODO: load any driver requests by last recorded or inputted distance
                    
                }
            })
        }
        
        
        
        
            
        
        if !driverOrders.isEmpty{
            driverOrders.removeAll()
        }
        //get orders sent to the driver
        let ordersForDriverQuery = PFQuery(className:"Order")
        ordersForDriverQuery.includeKey("restaurant")
        ordersForDriverQuery.includeKey("OrderingUser")
        ordersForDriverQuery.whereKey("driverToDeliver", equalTo: PFUser.currentUser()!)
        ordersForDriverQuery.whereKey("orderIsAcquired", equalTo: false)
    
    
        ordersForDriverQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let orders = objects {
                    for order in orders {
                        self.driverOrders.append(order)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        //get any driver available orders
        
        if !anyDriverOrders.isEmpty{
            anyDriverOrders.removeAll()
        }
        
        let ordersForAnyDriverQuery = PFQuery(className:"Order")
        ordersForAnyDriverQuery.includeKey("restaurant")
        ordersForAnyDriverQuery.includeKey("OrderingUser")
        ordersForAnyDriverQuery.whereKey("isAnyDriver", equalTo: true)
        
        ordersForAnyDriverQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let orders = objects {
                    for order in orders {
                        if (order["driverToDeliver"] == nil){
                            self.anyDriverOrders.append(order)
                        }
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        
    }
}
