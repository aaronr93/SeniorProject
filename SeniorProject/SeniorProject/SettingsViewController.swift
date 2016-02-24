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
    
    var checkThisField = [false, false, false]
    
    @IBOutlet weak var phoneField : UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userImage: PFImageView!
    @IBOutlet weak var emailField: UITextField!
    
    @IBAction func checkThisField(sender: UITextField) {
        //tags are 0,1,2 for username, phone#, email
        checkThisField[sender.tag] = true
    }
    
    @IBAction func touchedInFieldResetHighlight(sender: UITextField) {
        removeInputHighlightInField(sender)
    }
    
    
    
    @IBAction func doneChangingUsername(sender: UITextField) {
        if checkThisField[0] && !validatedUsername(sender) {
            if let userNameTemp = PFUser.currentUser()!["username"] as? String {
                if(userNameTemp == userNameField.text!){
                    print("...but username unchanged, so it's OK")
                    removeInputHighlightInField(userNameField)
                }
            }
        }
    }
    
    @IBAction func doneChangingPhoneNumber(sender: UITextField) {
        if checkThisField[1] {
            validatedPhoneNumber(sender)
        }
    }
    
    @IBAction func doneChangingEmailAddress(sender: UITextField) {
        if checkThisField[2] {
            validatedEmail(sender)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //userImage.image = UIImage(named: "...") // placeholder image
        //userImage.file = someObject.picture // remote image
        
        //userImage.loadInBackground()
        if let phone = PFUser.currentUser()!["phone"] as? String {
            phoneField.text = phone
        } else {
            phoneField.text = "none"
        }
        if let email = PFUser.currentUser()!["email"] as? String{
            emailField.text = email
        } else{
            emailField.text = "none"
        }
        if let userName = PFUser.currentUser()!["username"] as? String{
            userNameField.text = userName
        } else{
            userNameField.text = "none"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //need to use this instead of prepareForSegue with back buttons
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        var validatedSomething = false
        if (self.isMovingFromParentViewController()){
            //side note: short-circuits here save time...no data change = no validation check
            //save username if legitimate and changed...
            if(checkThisField[0] &&
                validatedUsername(userNameField)) {
                validatedSomething = true
                PFUser.currentUser()?.setObject(userNameField.text!, forKey: "username")
                NSLog("saved username")
            } else {
                if let userNameTemp = PFUser.currentUser()!["username"] as? String {
                    if(userNameTemp == userNameField.text!){
                        print("..but username unchanged, so it's OK")
                        removeInputHighlightInField(userNameField)
                    } else {
                        print("invalid username...not saved in DB")
                    }
                }
                print("invalid username...not saved in DB")
            }
            //...and phone...
            if(checkThisField[1] &&
                validatedPhoneNumber(phoneField)) {
                validatedSomething = true
                PFUser.currentUser()?.setObject(phoneField.text!, forKey: "phone")
                NSLog("saved phone")
            } else {
                print("invalid phone number...not saved in DB")
            }
            
            //...and email
            if(checkThisField[2] &&
                validatedEmail(emailField)) {
                validatedSomething = true
                PFUser.currentUser()?.setObject(emailField.text!, forKey: "email")
                NSLog("saved email")
            } else {
                print("invalid email address...not saved in DB")
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
