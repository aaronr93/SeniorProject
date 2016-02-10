//
//  ViewController.swift
//  SeniorProject
//
//  Created by Michael Kytka on 1/25/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse



class ViewController: UIViewController,UITextFieldDelegate {
    
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

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    func login(){
        let validation = Validation()
        if let usernameFieldText = usernameField.text {
            if let passwordFieldText = passwordField.text {
                let textFields = ["username":usernameFieldText,"password":passwordFieldText]
                validation.check(textFields, items:
                    [
                        "username" : ["required" : true, "min" : 4 , "max": 20],
                        "password" : ["required" : true , "min" : 4, "max" : 20]
                    ]
                )
                if (!validation.passed) {
                    //validation failed
                    print(validation.errors)
                } else {
                    //validation passed
                    PFUser.logInWithUsernameInBackground(usernameFieldText, password:passwordFieldText) {
                        (user: PFUser?, error: NSError?) -> Void in
                        if user != nil {
                            print("success!!")
                            self.performSegueWithIdentifier("loginSegue", sender: self)
                        } else {
                            print("Invalid loging credentials")
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        login()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        if textField == usernameField { // Switch focus to other text field
            passwordField.becomeFirstResponder()
        }else if textField == passwordField{
            passwordField.resignFirstResponder()
            login()
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameField.delegate = self;
        self.passwordField.delegate = self;
        usernameField.returnKeyType = UIReturnKeyType.Next
        passwordField.returnKeyType = UIReturnKeyType.Go
        //turn off borders
        usernameField.borderStyle = UITextBorderStyle.None
        
        passwordField.borderStyle = UITextBorderStyle.None
        
        passwordField.secureTextEntry = true
        
        //create CA Layer for each field
        let borderBottomUser = CALayer()
        let borderBottomPass = CALayer()
        let color = UIColor.grayColor()
        
        //create the bottom border and add to the sublayer
        addBorderToTextField(borderBottomUser, field: usernameField, color: color)
        addBorderToTextField(borderBottomPass, field: passwordField, color: color)
        
        
    }
    

}

