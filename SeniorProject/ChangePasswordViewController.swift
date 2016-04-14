//
//  ChangePasswordViewController.swift
//  Foodini
//
//  Created by Michael Kytka on 3/3/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
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
        // Remove borders from text fields
        currentPasswordField.borderStyle = .None
        newPasswordField.borderStyle = .None
        confirmPassword.borderStyle = .None
        
        // Create CA Layer for each field
        let borderCurrent = CALayer()
        let borderNew = CALayer()
        let borderConfirm = CALayer()
        let color = UIColor.lightGrayColor()
        
        // Create the bottom border and add to the sublayer
        addBorderToTextField(borderCurrent, field: currentPasswordField, color: color)
        addBorderToTextField(borderNew, field: newPasswordField, color: color)
        addBorderToTextField(borderConfirm, field: confirmPassword, color: color)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == currentPasswordField {
            newPasswordField.becomeFirstResponder()
            return true
        } else if textField == newPasswordField {
            confirmPassword.becomeFirstResponder()
            return true
        } else if textField == confirmPassword {
            changePassword()
            return true
        } else {
            return true
        }
    }
    
    @IBAction func submitButtonTapped(sender: UIButton) {
        changePassword()
    }
    
    func changePassword() {
        func alert(title: String, message: String) {
            let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                ()//don't need to do anything
            }))
            
            self.presentViewController(refreshAlert, animated: true, completion: nil)
        }
        var currentUser = PFUser.currentUser()
        
        if let password = currentPasswordField.text {
            if validatedPassword(self.newPasswordField.text!) {
                PFUser.logInWithUsernameInBackground((currentUser?.username)!, password:password) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if user != nil {
                        if self.newPasswordField.text == self.confirmPassword.text{
                            //passwords are the same so change password
                            currentUser = PFUser.currentUser()
                            currentUser?.password = self.newPasswordField.text
                            currentUser?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                                if error != nil{
                                    alert("Error", message: "New password not changed.")
                                } else{
                                    alert("Success", message: "You have successfully changed your password.\nPlease log in again.")
                                }
                            })
                            
                        } else {
                            //user needs to re-enter password
                            alert("Error", message: "Passwords do not match")
                            
                        }
                    } else {
                        alert("Error", message: "Current password is incorrect")
                    }
                }
            } else{
                alert("Error", message: "Please enter a valid current password")
            }
        } else{
            alert("Error", message: "Please enter your current password")
        }

    }
}
