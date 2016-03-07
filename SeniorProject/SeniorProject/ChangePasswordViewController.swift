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
        
        var currentUser = PFUser.currentUser()
        
        if let password = currentPasswordField.text{
            if validatedPassword(password){
                PFUser.logInWithUsernameInBackground((currentUser?.username)!, password:password) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if user != nil {
                        print(self.newPasswordField.text! + " " + self.confirmPassword.text!)
                        if self.newPasswordField.text == self.confirmPassword.text{
                            //passwords are the same so change password
                            currentUser = PFUser.currentUser()
                            currentUser?.password = self.newPasswordField.text
                            currentUser?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                                if error == nil{
                                    print("success")
                                }else{
                                    print("password not changed")
                                }
                            })
                            
                        }else{
                            //user needs to re-enter password
                            print("passwords dont match...try again")
                        }
                    } else {
                        print("Invalid loging credentials")
                    }
                }
            }
        }
    }
}
