//
//  CustomerDestinations.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 3/7/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import Parse

class CustomerDestinations {
    var history = [Destination]()
    var destinationID = ""
    let destinationQuery = PFQuery(className: "CustomerDestinations")
    
    func add(destination: Destination) {
        if !history.contains( {$0.name == destination.name} ) {
            history.append(destination)
        } else {
            logError("Destination already exists.")
        }
    }
    
    func remove(destination: Destination) {
        if let removeIndex = history.indexOf( {$0.name == destination.name} ) {
            history.removeAtIndex(removeIndex)
        } else {
            logError("Destination item to remove does not exist.")
        }
    }
    
    func destinationItemToPFObject(destinationItem: Destination) -> PFObject {
        let user = PFUser.currentUser()!
        let item = PFObject(className: "CustomerDestinations")
        item["customer"] = user
        // TODO: Add GeoPoint later (Next sprint)
        item["name"] = destinationItem.name
        return item
    }
    
    func addDestinationItemToDB(destinationItem: Destination, completion: (success: Bool, id: String?) -> Void){
        let parseDestinationItem = destinationItemToPFObject(destinationItem)
        parseDestinationItem.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            if (success) {
                completion(success: true, id: parseDestinationItem.objectId)
            } else {
                completion(success: false, id: nil)
            }
        })
    }
    
    func getDestinationItemsFromParse(completion: (success: Bool) -> Void) {
        let user = PFUser.currentUser()!
        // Only find destinations for the current user
        destinationQuery.whereKey("customer", equalTo: user)
        
        destinationQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let items = objects {
                    for item in items {
                        let name = item["name"] as! String
                        let id = item.objectId!
                        let destinationItem = Destination(name: name, id: id)
                        self.add(destinationItem)
                        // Populate the history of destinations
                    }
                    completion(success: true)
                }
            } else {
                // Log details of the failure
                logError("\(error!) \(error!.userInfo)")
                completion(success: false)
            }
        }
    }
}