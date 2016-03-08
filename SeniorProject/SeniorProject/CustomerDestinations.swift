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
            print("Destination already exists.")
        }
    }
    
    func remove(destination: Destination) {
        if let removeIndex = history.indexOf( {$0.name == destination.name} ) {
            history.removeAtIndex(removeIndex)
        } else {
            print("Destination item to remove does not exist.")
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
    
    func addDestinationItemToDB(destinationItem: Destination) {
        let parseDestinationItem = destinationItemToPFObject(destinationItem)
        
        let alreadyThereQuery = PFQuery(className: "CustomerDestinations")
        alreadyThereQuery.whereKey("name", equalTo: parseDestinationItem["name"])
        alreadyThereQuery.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                if let item = object {
                    if item["name"] as! String != parseDestinationItem["name"] as! String {
                        parseDestinationItem.saveInBackground()
                    } else {
                        print("Item \(parseDestinationItem["name"]) already exists")
                    }
                }
            } else {
                print(error)
            }
        }
        
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
                        let destinationItem = Destination(name: name)
                        self.add(destinationItem)
                        // Populate the history of destinations
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
}