//
//  GetThatOrderTableViewController.swift
//  SeniorProject
//
//  Created by Michael Kytka on 2/20/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class RestaurantCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
}

class FoodItemCell: UITableViewCell {
    @IBOutlet weak var foodItem: UILabel!
    @IBOutlet weak var foodDescription: UILabel!
}

class DeliveryItemCell: UITableViewCell {
    
    @IBOutlet weak var deliveryTitle: UILabel!
    
    @IBOutlet weak var value: UILabel!
   
}


class GetThatOrderTableViewController: UITableViewController {
    var sectionHeaders = ["Restaurant","Food","Delivery"]
    var deliverySectionTitles = ["Deliver To","Location","Expires In"]
    
    var restaurantName : String = ""
    var orderID : String = ""
    var deliveryTo : String = ""
    var location : String = ""
    var expiresIn : String = ""
    var foodItems = [PFObject]()
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return foodItems.count
        case 2:
            return deliverySectionTitles.count
        default:
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return sectionHeaders[0]
        case 1:
            return sectionHeaders[1]
        case 2:
            return sectionHeaders[2]
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let rc = tableView.dequeueReusableCellWithIdentifier("restaurantCell", forIndexPath: indexPath) as! RestaurantCell
            
            var rName : String = restaurantName
            rName.replaceRange(rName.startIndex...rName.startIndex, with: String(rName[rName.startIndex]).capitalizedString)
            
            rc.name.text = rName
            
            return rc
        }else if indexPath.section == 1{
            let fc = tableView.dequeueReusableCellWithIdentifier("foodCell", forIndexPath: indexPath) as! FoodItemCell
            fc.foodItem.text = foodItems[indexPath.row]["food"]["name"] as? String
            fc.foodDescription.text = foodItems[indexPath.row]["description"] as? String
            return fc
        }else if indexPath.section == 2{
            let dc = tableView.dequeueReusableCellWithIdentifier("deliveryCell", forIndexPath: indexPath) as! DeliveryItemCell
            dc.deliveryTitle.text = deliverySectionTitles[indexPath.row]
            var value : String = ""
            switch indexPath.row{
            case 0:
                value = deliveryTo
            case 1:
                value = location
            case 2:
                value = expiresIn
            default:
                value = ""
            }
            dc.value.text = value
            return dc
        }
        
        
        let cell:UITableViewCell! = nil
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = indexPath.section
        
        switch section {
        case 0: return 44
        case 1: return 60
        case 2: return 44
        default: return 44
        }
    }
    

    
    override func viewDidLoad() {
        //get orders sent to the driver
        let itemsForOrderQuery = PFQuery(className:"OrderedItems")
        itemsForOrderQuery.includeKey("food")
        itemsForOrderQuery.includeKey("order")
        itemsForOrderQuery.whereKey("order", equalTo: PFObject(withoutDataWithClassName: "Order", objectId: orderID))
        
            
        itemsForOrderQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let items = objects {
                    for item in items {
                        self.foodItems.append(item)
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
