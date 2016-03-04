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
    
    @IBOutlet weak var phoneField : UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userImage: PFImageView!
    @IBOutlet weak var emailField: UITextField!
    
    @IBAction func touchedInFieldResetHighlight(sender: UITextField) {
        removeInputHighlightInField(sender)
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
        if let phone = PFUser.currentUser()!["phone"] as? String {
            phoneField.text = phone
            originalPhone = phone
        } else {
            phoneField.text = "none"
        }
        if let email = PFUser.currentUser()!["email"] as? String{
            emailField.text = email
            originalEmail = email
        } else{
            emailField.text = "none"
        }
        if let userName = PFUser.currentUser()!["username"] as? String{
            userNameField.text = userName
            originalUserName = userName
        } else{
            userNameField.text = "none"
        }
    }

   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //need to use this instead of prepareForSegue with back buttons
    override func viewDidDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        var validatedSomething = false
        if (self.isMovingFromParentViewController()){
            //side note: short-circuits here save time...no data change = no validation check
            //save username if legitimate and changed...
            if(userNameField.text! != originalUserName && //dirrerent and valid //this will short-circuit to avoid DB call if unchanged
                validatedUsername(userNameField.text!)) {
                validatedSomething = true
                PFUser.currentUser()?.setObject(userNameField.text!, forKey: "username")
                NSLog("saved username")
            } else if(userNameField.text! == originalUserName){ //same
                print("username unchanged--not saved in DB")
            } else { //invalid
                print("invalid username not saved in DB")
            }
            //...and phone...
            if(phoneField.text! != originalPhone && //different and valid
                validatedPhoneNumber(phoneField.text!)) {
                validatedSomething = true
                PFUser.currentUser()?.setObject(phoneField.text!, forKey: "phone")
                NSLog("saved phone")
            } else if(phoneField.text! == originalPhone){ //same
                print("phone number unchanged--not saved in DB")
                removeInputHighlightInField(phoneField)
            } else { //invalid
                print("invalid phone number not saved in DB")
            }
            
            //...and email
            if(emailField.text! != originalEmail && //different and valid
                validatedEmail(emailField.text!)) {
                validatedSomething = true
                PFUser.currentUser()?.setObject(emailField.text!, forKey: "email")
                NSLog("saved email")
            } else if(emailField.text! == originalEmail) { //same
                print("email address unchanged--not saved in DB")
                removeInputHighlightInField(emailField)
            } else { //invalid
                print("invalid email address not saved in DB")
            }
            
            if(validatedSomething) {//only save once for all updates
                PFUser.currentUser()?.saveInBackground()
            }
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        phoneField.resignFirstResponder()
        userNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        super.touchesBegan(touches, withEvent: event)
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
