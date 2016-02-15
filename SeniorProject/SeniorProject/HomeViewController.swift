//
//  HomeViewController.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/9/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController, newOrderViewDelegate {
    
    
    
    func cancelNewOrder(newOrderVC: NewOrderViewController) {
        newOrderVC.navigationController?.popViewControllerAnimated(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let newOrderVC = segue.destinationViewController as! NewOrderViewController
        // Pass the selected object to the new view controller.
        if segue.identifier == "newOrder"{
            let newOrder = segue.destinationViewController as! NewOrderViewController
            newOrder.delegate = self
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
