//
//  ChangePasswordViewController.swift
//  SeniorProject
//
//  Created by Michael Kytka on 3/3/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    @IBAction func currentPasswordEdit(sender: UITextField) {
        currentPasswordField.becomeFirstResponder()
    }
    
    @IBAction func newPasswordEdit(sender: UITextField) {
        newPasswordField.becomeFirstResponder()
    }
    
    @IBAction func confirmPasswordEdit(sender: UITextField) {
        confirmPassword.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        currentPasswordField.secureTextEntry = true
        newPasswordField.secureTextEntry = true
        confirmPassword.secureTextEntry = true
    }
    
    @IBAction func submitButtonTapped(sender: UIButton) {
        
        let currentUser = PFUser.currentUser()
        
        if let password = currentPasswordField.text{
            if validatedPassword(password){
                if currentUser?.password == password{
                    print("here")
                    if let newPass = newPasswordField.text{
                        if let confirm = confirmPassword.text{
                            if newPass == confirm{
                                currentUser?.password = newPass
                                do{
                                    try currentUser?.save()
                                }catch {
                                    print(error)
                                }
                                
                            }else{
                                //passwords do not match
                            }
                        }
                    }
                }
            }
        }
    }
}
