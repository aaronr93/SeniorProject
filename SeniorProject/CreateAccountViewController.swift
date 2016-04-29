//
//  CreateAccountViewController.swift
//  Foodini
//
//  Created by Michael Kytka on 1/25/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
//import Parse

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBAction func touchedInFieldResetHighlight(sender: UITextField) {
        showGoodInputInField(sender)
    }
    
    let newAccount = CreateAccount()
    
    @IBAction func usernameChanged(sender: UITextField) {
        newAccount.username = sender.text
    }
    @IBAction func usernameEditComplete(sender: UITextField) {
        if validatedUsername(usernameField.text!) {
            showGoodInputInField(usernameField)
        } else {
            showBadInputWarningInField(usernameField)
        }
    }
    
    @IBAction func phoneNumberChanged(sender: UITextField) {
        newAccount.phone = sender.text
    }
    @IBAction func phoneNumberEditComplete(sender: UITextField) {
        if validatedPhoneNumber(phoneNumberField.text!) {
            showGoodInputInField(phoneNumberField)
        } else {
            showBadInputWarningInField(phoneNumberField)
        }
    }
    
    @IBAction func emailChanged(sender: UITextField) {
        newAccount.email = sender.text
    }
    @IBAction func emailEditComplete(sender: UITextField) {
        if validatedEmail(emailField.text!) {
            showGoodInputInField(emailField)
        } else {
            showBadInputWarningInField(emailField)
        }
    }
    
    @IBAction func passwordChanged(sender: UITextField) {
        newAccount.password = sender.text
        newAccount.passwordConfirm = ""
        confirmPasswordField.text = ""
        showGoodInputInField(confirmPasswordField)
    }
    @IBAction func passwordEditComplete(sender: UITextField) {
        if validatedPassword(sender.text!) {
            showGoodInputInField(sender)
        } else {
            showBadInputWarningInField(sender)
        }
    }
    
    @IBAction func confirmPasswordChanged(sender: UITextField) {
        newAccount.passwordConfirm = sender.text
    }
    @IBAction func confirmPasswordEditComplete(sender: UITextField) {
        if validatedPassword(sender.text!) && newAccount.confirmPasswordEqualsPassword() {
            showGoodInputInField(confirmPasswordField)
        } else {
            showBadInputWarningInField(confirmPasswordField)
        }
    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        validate()
        if newAccount.isValidated == true {
            self.performSegueWithIdentifier("validateSegue", sender: self)
        } else {
            NSLog("Account not validated. Please fix the appropriate fields.")
        }
    }
    
    func validate() {
        if validatedUsername(usernameField.text!) &&
            validatedPhoneNumber(phoneNumberField.text!) &&
            validatedEmail(emailField.text!) &&
            validatedPassword(passwordField.text!) &&
            validatedPassword(confirmPasswordField.text!) &&
            newAccount.checkPasswordIsNotHorrible() &&
            newAccount.confirmPasswordEqualsPassword() {
                newAccount.isValidated = true
                showGoodInputInField(usernameField)
                showGoodInputInField(phoneNumberField)
                showGoodInputInField(emailField)
                showGoodInputInField(passwordField)
                showGoodInputInField(confirmPasswordField)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        switch textField {
        case usernameField: // Switch focus to other text field
            phoneNumberField.becomeFirstResponder()
        case phoneNumberField:
            emailField.becomeFirstResponder()
        case emailField:
            passwordField.becomeFirstResponder()
        case passwordField:
            confirmPasswordField.becomeFirstResponder()
        case confirmPasswordField:
            confirmPasswordField.resignFirstResponder()
        default:
            NSLog("bad case in textFieldShouldReturn")
        }
        return true
    }
    
    func createBorder(layer: CALayer,borderWidth: Double,color: UIColor) -> CALayer? {
        let borderWidthL = CGFloat(borderWidth)
        layer.borderColor = color.CGColor
        layer.borderWidth = borderWidthL
        return layer
    }
    
    func addBorderToTextField(layer: CALayer,field: UITextField, color: UIColor) {
        let bw = 1.0
        //create the bottom border and add to the sublayer
        field.layer.addSublayer(createBorder(layer,borderWidth: bw,color: color)!)
        field.layer.masksToBounds = true
        layer.frame = CGRect(x: 0, y: field.frame.height - 0.5, width: field.frame.width , height: field.frame.height - 0.5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //unhide navigation bar
        navigationController?.navigationBarHidden = false

        //add bottom borders
        let borderBottom1 = CALayer()
        let borderBottom2 = CALayer()
        let borderBottom3 = CALayer()
        let borderBottom4 = CALayer()
        let borderBottom5 = CALayer()
        let color = UIColor.lightGrayColor()
        
        usernameField.delegate = self
        phoneNumberField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        usernameField.becomeFirstResponder()
        
        addBorderToTextField(borderBottom1, field: usernameField, color: color)
        addBorderToTextField(borderBottom2, field: passwordField, color: color)
        addBorderToTextField(borderBottom3, field: confirmPasswordField, color: color)
        addBorderToTextField(borderBottom4, field: phoneNumberField, color: color)
        addBorderToTextField(borderBottom5, field: emailField, color: color)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        usernameField.resignFirstResponder()
        phoneNumberField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        confirmPasswordField.resignFirstResponder()
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "validateSegue" {
            let dest = segue.destinationViewController as! FinishCreateAccountViewController
            dest.newAccount = newAccount
        }
    }

}
