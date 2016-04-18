//
//  HomeViewController.swift
//  Foodini
//
//  Created by Aaron Rosenberger on 2/9/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

class HomeViewController: UIViewController, NewOrderViewDelegate {
    
    @IBOutlet weak var logo:UIImageView!
    
    func cancelNewOrder(newOrderVC: NewOrderViewController) {
        if !newOrderVC.order.isEmpty() {
            let refreshAlert = UIAlertController(title: "Cancel", message: "Are you sure you want to cancel this order?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { (action: UIAlertAction!) in
                newOrderVC.navigationController?.popViewControllerAnimated(true)
            }))
            refreshAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            presentViewController(refreshAlert, animated: true, completion: nil)
        } else {
            newOrderVC.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func orderSaved(newOrderVC: NewOrderViewController){
        newOrderVC.navigationController?.popViewControllerAnimated(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //set installation user for push notifications
        let installation = PFInstallation.currentInstallation()
        installation["user"] = PFUser.currentUser()
        print(UIDevice.currentDevice().modelName)
        switch UIDevice.currentDevice().modelName {
            case "iPhone 5":
                break
            case "iPhone 5s":
                break
            case "iPhone 6":
                break
            case "iPhone 6 Plus":
                break
            case "iPhone 6s":
                break
            case "iPhone 6s Plus":
                break
            case "Simulator":
                break
            default:
                logo.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let newOrderVC = segue.destinationViewController as! NewOrderViewController
        // Pass the selected object to the new view controller.
        if segue.identifier == "newOrder" {
            let newOrder = segue.destinationViewController as! NewOrderViewController
            newOrder.delegate = self
        } else if segue.identifier == "driverSegue" {
            let tabs = segue.destinationViewController as! UITabBarController
            let orders = tabs.viewControllers![0] as! DriverOrdersViewController
            let restaurants = tabs.viewControllers![1] as! DriverRestaurantsViewController
            
            orders.tabBarItem.selectedImage = UIImage(named: "orders_selected")
            orders.tabBarItem.image = UIImage(named: "orders")
            
            restaurants.tabBarItem.selectedImage = UIImage(named: "restaurants_selected")
            restaurants.tabBarItem.image = UIImage(named: "restaurants")

        }
    }

}
