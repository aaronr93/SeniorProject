//
//  SettingsViewController.swift
//  Foodini
//
//  Created by Zach Nafziger on 2/16/16.
//  Created by Aaron Rosenberger on 2/15/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SettingsViewController: UIViewController {
    
    var originalUserName = "username not loaded...this is here to fail validation"
    var originalPhone = "phone num not loaded"
    var originalEmail = "email addr not loaded"
    
    let currentUser = PFUser.currentUser()!
    
    @IBOutlet weak var phoneField : UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    @IBAction func touchedInFieldResetHighlight(sender: UITextField) {
        removeInputHighlightInField(sender)
    }
    
    @IBAction func logoutButtonTapped(sender: UIButton) {
        if currentUser.objectId != nil {
            PFUser.logOut()
            performSegueWithIdentifier("unwindSegueLogoutFromSettingsController", sender: self)
        } else {
            logError("PFUser logout error")
        }
    }
    
    @IBAction func deleteButtonTapped(sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Confirm Account Removal", message: "Are you sure you want to delete your Foodini account? (This action cannot be undone.)", preferredStyle: UIAlertControllerStyle.ActionSheet)
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { (action: UIAlertAction!) in
            self.currentUser.setObject(true, forKey: "deleted")
            self.currentUser.saveInBackgroundWithBlock({ (x: Bool, error: NSError?) -> Void in
                if error != nil {
                    logError("error in delete account save")
                } else {
                    PFUser.logOut()
                    self.performSegueWithIdentifier("unwindSegueLogoutFromSettingsController", sender: self)
                }
            })
        }))
        refreshAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func doneChangingUsername(sender: UITextField) {
        if (sender.text! != originalUserName) { //if same as before, don't highlight
            if validatedUsername(sender.text!) {
                removeInputHighlightInField(sender)
            } else {
                showBadInputWarningInField(sender)
            }
        }
    }
    
    @IBAction func doneChangingPhoneNumber(sender: UITextField) {
        if (sender.text! != originalPhone) { //if same as before, don't highlight
            if validatedPhoneNumber(sender.text!) {
                removeInputHighlightInField(sender)
            } else {
                showBadInputWarningInField(sender)
            }
        }
    }
    
    @IBAction func doneChangingEmailAddress(sender: UITextField) {
        if (sender.text! != originalEmail) { //if same as before, don't highlight
            if validatedEmail(sender.text!) {
                removeInputHighlightInField(sender)
            } else {
                showBadInputWarningInField(sender)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //storing these items for the view to reuse would save several database calls
        let phone = currentUser.valueForKey("phone") as! String
        phoneField.text = phone
        originalPhone = phone
        
        let email = currentUser.email
        emailField.text = email
        originalEmail = email!
        
        let username = currentUser.username
        userNameField.text = username
        originalUserName = username!
        
        // Create CA Layer for each field
        let borderBottomUser = CALayer()
        let borderButtomPhone = CALayer()
        let borderBottomEmail = CALayer()
        let color = UIColor.lightGrayColor()
        
        // Create the bottom border and add to the sublayer
        addBorderToTextField(borderBottomUser, field: userNameField, color: color)
        addBorderToTextField(borderButtomPhone, field: phoneField, color: color)
        addBorderToTextField(borderBottomEmail, field: emailField, color: color)
    }

    //need to use this instead of prepareForSegue with back buttons
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        var validatedSomething = false
        if (self.isMovingFromParentViewController()) {
            //side note: short-circuits here save time...no data change = no validation check
            //save username if legitimate and changed...
            if (userNameField.text! != originalUserName && validatedUsername(userNameField.text!)) {
                //dirrerent and valid //this will short-circuit to avoid DB call if unchanged
                validatedSomething = true
                currentUser.username = userNameField.text!
            } else if (userNameField.text! == originalUserName) {
                // username unchanged--not saved in DB
            } else {
                // invalid username not saved in DB
            }
            //...and phone...
            if (phoneField.text! != originalPhone && validatedPhoneNumber(phoneField.text!)) {
                //different and valid
                validatedSomething = true
                currentUser.setObject(phoneField.text!, forKey: "phone")
            } else if (phoneField.text! == originalPhone) {
                // phone number unchanged--not saved in DB
                removeInputHighlightInField(phoneField)
            } else {
                // invalid phone number--not saved in DB
            }
            
            //...and email
            if (emailField.text! != originalEmail && validatedEmail(emailField.text!)) {
                //different and valid
                validatedSomething = true
                currentUser.email = emailField.text!
            } else if (emailField.text! == originalEmail) {
                // email address unchanged--not saved in DB
                removeInputHighlightInField(emailField)
            } else {
                // invalid email address--not saved in DB
            }
            
            if (validatedSomething) {
                //only save once for all updates
                currentUser.saveInBackground()
            }
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        phoneField.resignFirstResponder()
        userNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        super.touchesBegan(touches, withEvent: event)
    }

}
