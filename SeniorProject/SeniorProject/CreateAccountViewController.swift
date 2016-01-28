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
