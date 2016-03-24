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
            logError("Failure")
        }
    }
    
    func createAccount() {
        let user = User()
        addNewUser(user)
        sendToParse(user)
    }
    
    func addNewUser(user: User) {
        if let newAcct = newAccount {
            if let username = newAcct.username {
                user.username = username
            }
            if let phone = newAcct.phone {
                user.phone = phone
            }
            if let email = newAcct.email {
                user.email = email
            }
            if let password = newAcct.password {
                user.password = password
            }
            user.deleted = false
        }
    }
    
    func sendToParse(user: PFUser) {
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                error.userInfo.setObjectForKey(errorString, "error") // Try to fix the Swift 2.2 break
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                logError(errorString!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //unhide navigation bar
        navigationController?.navigationBarHidden = false
    }
    
    
}

