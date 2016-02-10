//
//  CreateAccountViewController.swift
//  SeniorProject
//
//  Created by Michael Kytka on 1/25/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class CreateAccountViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    let newAccount = CreateAccount()
    
    @IBAction func usernameChanged(sender: UITextField) {
        newAccount.username = sender.text
    }
    
    @IBAction func phoneNumberChanged(sender: UITextField) {
        newAccount.phone = sender.text
    }
    
    @IBAction func emailChanged(sender: UITextField) {
        newAccount.email = sender.text
    }
    
    @IBAction func passwordChanged(sender: UITextField) {
        newAccount.password = sender.text
    }
    
    @IBAction func confirmPasswordChanged(sender: UITextField) {
        // Editing did end
        newAccount.passwordConfirm = sender.text
        
        if (newAccount.confirmPasswordEqualsPassword()) {
            removeBadInputWarningInField(confirmPasswordField)
        } else {
            showBadInputWarningInField(confirmPasswordField)
        }
    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        validate()
        if newAccount.isValidated == true {
            self.performSegueWithIdentifier("validateSegue", sender: self)
            print("Validated!")
        } else {
            print("Not validated.")
        }
    }
    
    func validate() {
        if validatedUsername() &&
            phoneNumberField.text != "" &&
            emailField.text != "" &&
            validatedPassword() &&
            confirmPasswordField.text != "" &&
            newAccount.checkPasswordIsNotHorrible() &&
            newAccount.confirmPasswordEqualsPassword() {
                newAccount.isValidated = true
                removeBadInputWarningInField(usernameField)
                removeBadInputWarningInField(phoneNumberField)
                removeBadInputWarningInField(emailField)
                removeBadInputWarningInField(passwordField)
                removeBadInputWarningInField(confirmPasswordField)
                
                //*****************************************
                // TODO: Make the validation better!
                //*****************************************
                
        }
    }
    
    func validatedUsername() -> Bool {
        let validation = Validation()
        if let fieldText = usernameField.text {
            let textFields = ["username": fieldText]
            validation.check(textFields, items: [
                "username" : ["required": true, "min": 4, "max": 20]
            ])
        }
        if (!validation.passed || usernameExistsInParse()) {
            //validation failed
            print(validation.errors)
            showBadInputWarningInField(usernameField)
            return false
        } else {
            removeBadInputWarningInField(usernameField)
            return true
        }
    }
    
    func usernameExistsInParse() -> Bool {
        // Synchronous and is skipped by iOS as a long-running blocking function
        let query = PFQuery(className:"User")
        var usernameExists = true
        query.whereKey("username", equalTo: usernameField.text!)
        do {
            let results: [PFObject] = try query.findObjects()
            print(results.count)
            if results.count > 0 {
                print("Username already exists.")
                usernameExists = true
            } else {
                usernameExists = false
            }
        } catch {
            print(error)
        }
        return usernameExists
    }
    
    func validatedPassword() -> Bool {
        let validation = Validation()
        if let fieldText = passwordField.text {
            let textFields = ["password": fieldText]
            validation.check(textFields, items: [
                "password" : ["required": true, "min": 6, "max": 20]
            ])
        }
        if (!validation.passed) {
            //validation failed
            print(validation.errors)
            showBadInputWarningInField(passwordField)
            return false
        } else {
            removeBadInputWarningInField(passwordField)
            return true
        }
    }
    
    func showBadInputWarningInField(field: UITextField) {
        // Called when the text in the param of type UITextField is invalid.
        let myColor: UIColor = UIColor(red: 0.5, green: 0.5, blue: 0, alpha: 1.0 )
        field.layer.borderColor = myColor.CGColor
    }
    
    func removeBadInputWarningInField(field: UITextField) {
        field.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        if textField == usernameField { // Switch focus to other text field
            phoneNumberField.becomeFirstResponder()
        } else if textField == phoneNumberField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            confirmPasswordField.becomeFirstResponder()
        } else if textField == confirmPasswordField {
            confirmPasswordField.resignFirstResponder()
        }
        return true
    }
    
    func createBorder(layer: CALayer,borderWidth: Double,color: UIColor) -> CALayer?
    {
        let borderWidthL = CGFloat(borderWidth)
        layer.borderColor = color.CGColor
        layer.borderWidth = borderWidthL
        
        return layer
    }
    
    func addBorderToTextField(layer: CALayer,field: UITextField, color: UIColor){
        let bw = 1.0
        
        //create the bottom border and add to the sublayer
        field.layer.addSublayer(createBorder(layer,borderWidth: bw,color: color)!)
        field.layer.masksToBounds = true

        
        layer.frame = CGRect(x: 0, y: field.frame.height - 1.0, width: field.frame.width , height: field.frame.height - 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //unhide navigation bar
        navigationController?.navigationBarHidden = false
        passwordField.secureTextEntry = true
        confirmPasswordField.secureTextEntry = true
        //add bottom borders
        let borderBottomUser = CALayer()
        let borderBottomPass = CALayer()
        let borderBottomConfirmPass = CALayer()
        let borderBottomPhone = CALayer()
        let borderBottomEmail = CALayer()
        let color = UIColor.grayColor()
        
        usernameField.delegate = self
        phoneNumberField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        usernameField.returnKeyType = UIReturnKeyType.Next
        phoneNumberField.returnKeyType = UIReturnKeyType.Next
        emailField.returnKeyType = UIReturnKeyType.Next
        passwordField.returnKeyType = UIReturnKeyType.Next
        confirmPasswordField.returnKeyType = UIReturnKeyType.Done
        
        addBorderToTextField(borderBottomUser, field: usernameField, color: color)
        addBorderToTextField(borderBottomPass, field: passwordField, color: color)
        addBorderToTextField(borderBottomConfirmPass, field: confirmPasswordField, color: color)
        addBorderToTextField(borderBottomPhone, field: phoneNumberField, color: color)
        addBorderToTextField(borderBottomEmail, field: emailField, color: color)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "validateSegue" {
            let svc = segue.destinationViewController as! FinishCreateAccountViewController
            svc.newAccount = newAccount
        }
    }

}
