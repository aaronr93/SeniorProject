//
//  CreateAccountViewController.swift
//  SeniorProject
//
//  Created by Michael Kytka on 1/25/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController
{
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBAction func phoneNumberChanged(sender: UITextField) {
        // Editing changed
        
    }
    
    @IBAction func emailChanged(sender: UITextField) {
        // Editing changed
        // Make sure it's correct email syntax
        // Look into services for confirming emails
        // OR we could just do phone number login
    }
    
    @IBAction func passwordChanged(sender: UITextField) {
        // Editing changed
    }
    
    @IBAction func confirmPasswordChanged(sender: UITextField) {
        // Editing did end
        if (confirmPasswordEqualsPassword()) {
            removeBadInputWarningInField(confirmPasswordField)
        } else {
            showBadInputWarningInField(confirmPasswordField)
        }
    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        // Touch up inside
        // Check to make sure the fields are filled out
        checkPasswordIsNotHorrible()
        confirmPasswordEqualsPassword()
    }
    
    @IBAction func finishButtonPressed(sender: UIButton) {
        
    }
    
    func checkPasswordIsNotHorrible() {
        if ((passwordField.text?.containsString(usernameField.text!)) != nil) {
            // username is contained in the password
            showBadInputWarningInField(passwordField)
        }
        if ((passwordField.text?.containsString("password")) != nil) {
            // The user tried to set the password as "password"
            
        }
    }
    
    func confirmPasswordEqualsPassword() -> Bool {
        if (confirmPasswordField.text == passwordField.text) {
            return true
        } else {
            return false
        }
    }
    
    func showBadInputWarningInField(field: UITextField) {
        // Called when the text in the param of type UITextField is invalid.
        // IDK, make a red border or something. Or just a notification.
    }
    
    func removeBadInputWarningInField(field: UITextField) {
        
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
    
        //add bottom borders
        let borderBottomUser = CALayer()
        let borderBottomPass = CALayer()
        let borderBottomConfirmPass = CALayer()
        let borderBottomPhone = CALayer()
        let borderBottomEmail = CALayer()
        let color = UIColor.grayColor()
        
        addBorderToTextField(borderBottomUser, field: usernameField, color: color)
        addBorderToTextField(borderBottomPass, field: passwordField, color: color)
        addBorderToTextField(borderBottomConfirmPass, field: confirmPasswordField, color: color)
        addBorderToTextField(borderBottomPhone, field: phoneNumberField, color: color)
        addBorderToTextField(borderBottomEmail, field: emailField, color: color)
        
        
    }
    
    
    

}
