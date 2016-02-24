//
//  CreateAccountViewController.swift
//  SeniorProject
//
//  Created by Michael Kytka on 1/25/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
//import Parse

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
    @IBAction func usernameEditComplete(sender: UITextField) {
        validatedUsername(usernameField)
    }
    
    @IBAction func phoneNumberChanged(sender: UITextField) {
        newAccount.phone = sender.text
    }
    @IBAction func phoneNumberEditComplete(sender: UITextField) {
        validatedPhoneNumber(phoneNumberField)
    }
    
    @IBAction func emailChanged(sender: UITextField) {
        newAccount.email = sender.text
    }
    @IBAction func emailEditComplete(sender: UITextField) {
        validatedEmail(emailField)
    }
    
    @IBAction func passwordChanged(sender: UITextField) {
        newAccount.password = sender.text
        newAccount.passwordConfirm = ""
        confirmPasswordField.text = ""
        removeInputHighlightInField(confirmPasswordField)
    }
    @IBAction func passwordEditComplete(sender: UITextField) {
        validatedPassword(sender)
    }
    
    @IBAction func confirmPasswordChanged(sender: UITextField) {
        newAccount.passwordConfirm = sender.text
    }
    @IBAction func confirmPasswordEditComplete(sender: UITextField) {
        if(validatedPassword(sender) &&
        newAccount.confirmPasswordEqualsPassword()) {
            showGoodInputInField(confirmPasswordField)
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
        if validatedUsername(usernameField) &&
            validatedPhoneNumber(phoneNumberField) &&
            validatedEmail(emailField) &&
            validatedPassword(passwordField) &&
            validatedPassword(confirmPasswordField) &&
            newAccount.checkPasswordIsNotHorrible() &&
            newAccount.confirmPasswordEqualsPassword() {
                newAccount.isValidated = true
                removeInputHighlightInField(usernameField)
                removeInputHighlightInField(phoneNumberField)
                removeInputHighlightInField(emailField)
                removeInputHighlightInField(passwordField)
                removeInputHighlightInField(confirmPasswordField)
                
                //*****************************************
                // TODO: Make the validation better!
                //*****************************************
                
        }
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        usernameField.resignFirstResponder()
        phoneNumberField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        confirmPasswordField.resignFirstResponder()
        super.touchesBegan(touches, withEvent: event)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "validateSegue" {
            let svc = segue.destinationViewController as! FinishCreateAccountViewController
            svc.newAccount = newAccount
        }
    }

}
