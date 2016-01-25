//
//  ViewController.swift
//  SeniorProject
//
//  Created by Michael Kytka on 1/25/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    let bottomBorder = CALayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //turn off borders
        usernameField.borderStyle = UITextBorderStyle.None
        
        passwordField.borderStyle = UITextBorderStyle.None
        
        
        //add a bottom border
        let borderBottomUser = CALayer()
        let borderTopUser = CALayer()
        let borderWidth = CGFloat(1.0)
        borderBottomUser.borderColor = UIColor.grayColor().CGColor
        borderTopUser.borderColor = UIColor.grayColor().CGColor
        borderBottomUser.frame = CGRect(x: 0, y: usernameField.frame.height - 1.0, width: usernameField.frame.width , height: usernameField.frame.height - 1.0)
        borderTopUser.frame = CGRect(x: 0, y: passwordField.frame.height - 1.0, width: passwordField.frame.width , height: passwordField.frame.height - 1.0)
        borderBottomUser.borderWidth = borderWidth
        borderTopUser.borderWidth = borderWidth
        usernameField.layer.addSublayer(borderBottomUser)
        usernameField.layer.masksToBounds = true
        passwordField.layer.addSublayer(borderTopUser)
        passwordField.layer.masksToBounds = true

    }
    

}

