//
//  LogInViewController.swift
//  SeniorProject
//
//  Created by Michael Kytka on 1/25/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

func showBadInputWarningInField(field: UITextField) {
    // Called when the text in the param of type UITextField is invalid.
    let myColor: UIColor = UIColor(red: 0.9, green: 0, blue: 0, alpha: 0.3 )
    field.layer.backgroundColor = myColor.CGColor
}

func showGoodInputInField(field: UITextField) {
    // Called when the text in the param of type UITextField is valid.
    let myColor: UIColor = UIColor(red: 0, green: 0.9, blue: 0, alpha: 0.3 )
    field.layer.backgroundColor = myColor.CGColor
}

func removeInputHighlightInField(field: UITextField) {
    field.layer.backgroundColor = UIColor.whiteColor().CGColor
}



class LogInViewController: UIViewController,UITextFieldDelegate {
    
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
                    //checks to see if the user's account has been deleted or not
                    
                        //validation passed
                        PFUser.logInWithUsernameInBackground(usernameFieldText, password:passwordFieldText) {
                            (user: PFUser?, error: NSError?) -> Void in
                            if user != nil {
                                if let modifiedStatus = PFUser.currentUser()?.objectForKey("deleted"){
                                    if modifiedStatus.boolValue == false{
                                        self.performSegueWithIdentifier("loginSegue", sender: self)
                                        //clear the password field after login attempt
                                        //prevents storage of password in the VC stack--otherwise it's usable after logout (security issue)
                                        self.passwordField.text = ""
                                        self.usernameField.text = "" //clear username to prevent inconsistencies in displayed name
                                            //certain program states could cause the wrong username to be displayed after logout
                                            //so it's a lot easier to instead just not display any username
                                    }
                                }
                            } else {
                                logError("Invalid loging credentials")
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
        
        //if the user is already logged in, immediately go to the HomeViewController
        let modifiedStatus = PFUser.currentUser()?.objectForKey("deleted")
        let currentUser = PFUser.currentUser()
        if currentUser != nil && modifiedStatus?.boolValue == false {
            performSegueWithIdentifier("loginSegue", sender: self)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        super.touchesBegan(touches, withEvent: event)
    }
    
    // MARK: - Navigation
    @IBAction func unwindSegueLogoutFromSettingsController(segue: UIStoryboardSegue) {}

}

