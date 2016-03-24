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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let newOrderVC = segue.destinationViewController as! NewOrderViewController
        // Pass the selected object to the new view controller.
        if segue.identifier == "newOrder" {
            let newOrder = segue.destinationViewController as! NewOrderViewController
            newOrder.delegate = self
        }
    }

}
