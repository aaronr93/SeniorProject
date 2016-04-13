//
//  InitViewController.swift
//  Foodini
//
//  Created by Zach Nafziger on 4/10/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class InitViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        //if the user is already logged in, immediately go to the HomeViewController
        let modifiedStatus = PFUser.currentUser()?.objectForKey("deleted")
        let currentUser = PFUser.currentUser()
        if currentUser != nil && modifiedStatus?.boolValue == false {
            dispatch_async(dispatch_get_main_queue()) {
                [unowned self] in
                self.performSegueWithIdentifier("homeSegue", sender: self)
            }
            
        } else{
            dispatch_async(dispatch_get_main_queue()) {
                [unowned self] in
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    @IBAction func unwindSegueLogoutFromSettingsController(segue: UIStoryboardSegue) {}
    @IBAction func unwindSegueLogoutFromChangePasswordController(segue: UIStoryboardSegue) {}
    


}
