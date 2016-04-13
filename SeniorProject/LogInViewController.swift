//
//  LogInViewController.swift
//  Foodini
//
//  Created by Michael Kytka on 1/25/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var error: UILabel!
    
    func login(completion: (success: Bool) -> Void) {
        //checks to see if the user's account has been deleted or not
        
        //validation passed
        if let username = usernameField.text {
            if let password = passwordField.text {
                PFUser.logInWithUsernameInBackground(username, password: password) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if user != nil {
                        let currentUser = PFUser.currentUser()!
                        let deleted = currentUser.valueForKey("deleted") as! Bool
                        if !deleted {
                            completion(success: true)
                        } else {
                            let currentUser = PFUser.currentUser()!
                            let notification = Notification(content: "Your account is deleted.", sendToID: currentUser.objectId!)
                            notification.push()
                            PFUser.logOut()
                            completion(success: false)
                        }
                    } else {
                        logError("Invalid loging credentials")
                        completion(success: false)
                    }
                }
            }
        }
        
    }

    func clearFields() {
        usernameField.text = ""
        passwordField.text = ""
    }
    
    func toggleEnabled(button: UIButton) {
        if button.enabled {
            button.enabled = false
        } else if !button.enabled {
            button.enabled = true
        }
    }
    
    func performLoginTasks() {
        toggleEnabled(login)
        login() { success in
            if success {
                // Account is NOT deleted; Login
                self.performSegueWithIdentifier("loginSegue", sender: self)
                //clear the password field after login attempt
                //prevents storage of password in the VC stack--otherwise it's usable after logout (security issue)
                //certain program states could cause the wrong username to be displayed after logout
                //so it's a lot easier to instead just not display any username
                self.clearFields()
            } else {
                self.error.hidden = false
                self.clearFields()
                self.toggleEnabled(self.login)
            }
        }
    }

    @IBAction func loginButtonPressed(sender: UIButton) {
        performLoginTasks()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        if textField == usernameField { // Switch focus to other text field
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            passwordField.resignFirstResponder()
            performLoginTasks()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        error.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameField.delegate = self;
        self.passwordField.delegate = self;
        
        // Turn off borders
        usernameField.borderStyle = UITextBorderStyle.None
        passwordField.borderStyle = UITextBorderStyle.None
        
        // Create CA Layer for each field
        let borderBottomUser = CALayer()
        let borderBottomPass = CALayer()
        let color = UIColor.lightGrayColor()
        
        // Create the bottom border and add to the sublayer
        addBorderToTextField(borderBottomUser, field: usernameField, color: color)
        addBorderToTextField(borderBottomPass, field: passwordField, color: color)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        super.touchesBegan(touches, withEvent: event)
    }
    
    

}

