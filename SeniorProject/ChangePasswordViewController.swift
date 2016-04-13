//
//  ChangePasswordViewController.swift
//  SeniorProject
//
//  Created by Michael Kytka on 3/3/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    @IBAction func currentPasswordEdit(sender: UITextField) {
        currentPasswordField.becomeFirstResponder()
    }
    
    @IBAction func newPasswordEdit(sender: UITextField) {
        newPasswordField.becomeFirstResponder()
    }
    
    @IBAction func confirmPasswordEdit(sender: UITextField) {
        confirmPassword.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        currentPasswordField.secureTextEntry = true
        newPasswordField.secureTextEntry = true
        confirmPassword.secureTextEntry = true
    }
    
    @IBAction func submitButtonTapped(sender: UIButton) {
        func badInfo(){
            let refreshAlert = UIAlertController(title: "Whoops!", message: "You typed something wrong... try again.", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                ()//don't need to do anything
            }))
            
            self.presentViewController(refreshAlert, animated: true, completion: nil)
        }
        var currentUser = PFUser.currentUser()
       
        if let password = currentPasswordField.text{
            if validatedPassword(self.newPasswordField.text!){
                PFUser.logInWithUsernameInBackground((currentUser?.username)!, password:password) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if user != nil {
                        if self.newPasswordField.text == self.confirmPassword.text{
                            //passwords are the same so change password
                            currentUser = PFUser.currentUser()
                            currentUser?.password = self.newPasswordField.text
                            currentUser?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                                if error != nil{
                                    logError("password not changed")
                                    let refreshAlert = UIAlertController(title: "Whoops!", message: "Something went wrong... try again.", preferredStyle: UIAlertControllerStyle.Alert)
                                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                                        ()//don't need to do anything
                                    }))
                                    
                                    self.presentViewController(refreshAlert, animated: true, completion: nil)
                                
                                } else{
                                    let refreshAlert = UIAlertController(title: "Password Changed", message: "Your password was successfully changed!", preferredStyle: UIAlertControllerStyle.Alert)
                                    
                                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                                        //need to log out or session becomes invalid
                                        PFUser.logOut()
                                        self.performSegueWithIdentifier("unwindToLogin", sender: self)
                                    }))
                                    
                                    self.presentViewController(refreshAlert, animated: true, completion: nil)
                                }
                            })
                            
                        }else{
                            //user needs to re-enter password
                            logError("passwords dont match...try again")
                            badInfo()

                        }
                    } else {
                        logError("Invalid login credentials")
                        badInfo()
                    }
                }
            } else{
                badInfo()
            }
        } else{
            badInfo()
        }
    }
}
