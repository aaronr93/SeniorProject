//
//  FinishCreateAccountViewController.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/8/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class FinishCreateAccountViewController: UIViewController
{
    @IBOutlet weak var terms: UISwitch!
    @IBOutlet weak var data: UISwitch!
    
    var newAccount: CreateAccount!
    
    @IBAction func finishButtonPressed(sender: UIButton) {
        if terms.on == true {
            createAccount()
            self.performSegueWithIdentifier("createAccountSegue", sender: self)
        } else {
            print("Failure")
        }
    }
    
    func createAccount() {
        let user = PFUser()
        addNewUser(user)
        sendToParse(user)
    }
    
    func addNewUser(user: PFUser) {
        if let newAcct = newAccount {
            if let username = newAcct.username {
                user.username = username
            }
            if let phone = newAcct.phone {
                user["phone"] = phone
            }
            if let email = newAcct.email {
                user.email = email
            }
            if let password = newAcct.password {
                user.password = password
            }
        }
    }
    
    func sendToParse(user: PFUser) {
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print(errorString)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //unhide navigation bar
        navigationController?.navigationBarHidden = false
    }
    
    
}

