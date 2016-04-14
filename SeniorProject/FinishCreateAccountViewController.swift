//
//  FinishCreateAccountViewController.swift
//  Foodini
//
//  Created by Aaron Rosenberger on 2/8/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class FinishCreateAccountViewController: UIViewController {
    @IBOutlet weak var terms: UISwitch!
    @IBOutlet weak var data: UISwitch!
    @IBOutlet weak var finish: UIButton!
    
    var newAccount: CreateAccount!
    
    @IBAction func accept(sender: UISwitch) {
        if sender.on {
            finish.enabled = true
        } else {
            finish.enabled = false
        }
    }
    
    @IBAction func finishButtonPressed(sender: UIButton) {
        if terms.on == true {
            createAccount()
            self.performSegueWithIdentifier("createAccountSegue", sender: self)
        } else {
            logError("Failure")
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
                user.setObject(phone, forKey: "phone")
            }
            if let email = newAcct.email {
                user.email = email
            }
            if let password = newAcct.password {
                user.password = password
            }
            user.setObject(false, forKey: "deleted")
        }
    }
    
    func sendToParse(user: PFUser) {
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error != nil {
                logError(error!)
                PFUser.logOut()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //unhide navigation bar
        navigationController?.navigationBarHidden = false
        finish.enabled = false
    }
    
}

