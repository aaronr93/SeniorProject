//
//  SettingsViewController.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 2/16/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var phoneField : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let phone = PFUser.currentUser()!["phone"] as? String {
            phoneField.text = phone
        } else {
            phoneField.text = "none"
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
