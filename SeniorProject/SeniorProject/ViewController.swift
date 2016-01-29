//
//  ViewController.swift
//  SeniorProject
//
//  Created by Michael Kytka on 1/25/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    let bottomBorder = CALayer()
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

