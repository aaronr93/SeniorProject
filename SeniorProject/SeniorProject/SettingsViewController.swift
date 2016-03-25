//
//  SettingsViewController.swift
//  SeniorProject
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
    @IBOutlet weak var userImage: PFImageView!
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
        currentUser.setObject(true, forKey: "deleted")
        currentUser.saveInBackgroundWithBlock({ (x: Bool, error: NSError?) -> Void in
            if error != nil {
                logError("error in delete account save")
            } else {
                PFUser.logOut()
                self.performSegueWithIdentifier("unwindSegueLogoutFromSettingsController", sender: self)
            }
        })
    }
    
    @IBAction func doneChangingUsername(sender: UITextField) {
        if (sender.text! != originalUserName) { //if same as before, don't highlight
            validatedUsername(sender.text!) //only run the DB call incurred here if it's a different username than before
        }
    }
    
    @IBAction func doneChangingPhoneNumber(sender: UITextField) {
        if (sender.text! != originalPhone) { //if same as before, don't highlight
            validatedPhoneNumber(sender.text!)
        }
    }
    
    @IBAction func doneChangingEmailAddress(sender: UITextField) {
        if (sender.text! != originalEmail) { //if same as before, don't highlight
            validatedEmail(sender.text!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //userImage.image = UIImage(named: "...") // placeholder image
        //userImage.file = someObject.picture // remote image
        
        //userImage.loadInBackground()
        
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
