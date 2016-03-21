//
//  HomeViewController.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/9/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, NewOrderViewDelegate {
    
    let POIs = PointsOfInterest()
    
    func cancelNewOrder(newOrderVC: NewOrderViewController) {
        newOrderVC.navigationController?.popViewControllerAnimated(true)
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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        addLocalPOIs(withQueryString: "Food")
    }
    
    func addLocalPOIs(withQueryString item: String) {
        // Search for nearby locations related to the argument for `searchFor`
        POIs.searchFor(item) { result in
            if result {
                // When we have all the results we want, check Parse
                // for restaurants we found that are already in Parse.
                self.POIs.saveRestaurantsToParse() { res in
                    if res {
                        // Success: restaurants found that weren't in Parse
                        // were added to Parse in the Restaurant class.
                        print("Saved new restaurants to Parse")
                    } else {
                        // Some kind of error occurred while trying to add
                        // new Restaurants to Parse.
                        logError("Didn't save new restaurants to Parse")
                    }
                }
            } else {
                // Some kind of error occurred while trying to
                // find nearby locations.
                logError("Couldn't find searched locations")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let newOrderVC = segue.destinationViewController as! NewOrderViewController
        // Pass the selected object to the new view controller.
        if segue.identifier == "newOrder" {
            let newOrder = segue.destinationViewController as! NewOrderViewController
            newOrder.delegate = self
        } else if segue.identifier == "imPickingUpFoodSegue" {
            let tabController = segue.destinationViewController as! UITabBarController
            let restaurantsTab = tabController.viewControllers![0] as! DriverRestaurantsViewController
            for loc in POIs.restaurants {
                restaurantsTab.prefs.addRestaurant(loc)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
