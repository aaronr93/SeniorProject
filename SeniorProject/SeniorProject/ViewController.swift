//
//  ViewController.swift
//  SeniorProject
//
//  Created by Michael Kytka on 1/25/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    func createBottomBorder(layer: CALayer,borderWidth: Double,color: UIColor) -> CALayer?
    {
        let borderWidthL = CGFloat(borderWidth)
        layer.borderColor = color.CGColor
        layer.borderWidth = borderWidthL
        
        return layer
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
        let bw = 1.0
        
        //create the bottom border and add to the sublayer
        usernameField.layer.addSublayer(createBottomBorder(borderBottomUser,borderWidth: bw,color:UIColor.grayColor())!)
        usernameField.layer.masksToBounds = true
         passwordField.layer.addSublayer(createBottomBorder(borderBottomPass,borderWidth: bw,color:UIColor.grayColor())!)
        passwordField.layer.masksToBounds = true
        
        borderBottomUser.frame = CGRect(x: 0, y: passwordField.frame.height - 1.0, width: usernameField.frame.width , height: usernameField.frame.height - 1.0)
        borderBottomPass.frame = CGRect(x: 0, y: passwordField.frame.height - 1.0, width: passwordField.frame.width , height: passwordField.frame.height - 1.0)

    }
    

}

