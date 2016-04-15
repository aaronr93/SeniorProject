//
//  validation.swift
//  Foodini
//
//  Created by Michael Kytka on 2/1/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import UIKit
import Parse

extension String {
    var length: Int {
        return characters.count
    }
}

class Validation {
    var errors = [String]()
    var passed : Bool = false
    
    func addError(error: String){
        errors += [error]
    }
    
    func check(values: [String : String], items: [String : [String : AnyObject]]){
        for (item,rules) in items {
            for (rule,rule_value) in rules{
                let value = values[item]
                if let val = value{
                    if rule == "required" && val.isEmpty {
                        //if value is required but the value is an empty string
                        addError(item + " is required")
                    }else if val.isEmpty == false{
                        switch rule{
                            //here are all the possible rules. Add as needed
                        case "min":
                            if let rv = rule_value as? Int{
                                if val.length < rv{
                                    addError("\(item) must be a minimum of \(rv) characters.")
                                }
                            }
                        case "max":
                            if let rv = rule_value as? Int{
                                if val.length > rv{
                                    addError("\(item) must be a maximum of \(rv) characters.")
                                }
                            }
                        case "lengthEqualTo":
                            if let rv = rule_value as? Int{
                                if val.length != rv{
                                    addError("\(item) must be \(rv) characters long.")
                                }
                            }
                        case "doesNotContain":
                            if let rv = rule_value as? String {
                                if (val.containsString(rv)) {
                                    // The given value contains "rv"'s value
                                    addError("\(item) must not contain \(rv)")
                                }
                            }
                        case "stringNotEqualTo":
                            if let rv = rule_value as? String {
                                if (val == rv) {
                                    addError("\(item) must not equal \(rv)")
                                }
                            }
                        default:
                            ()
                        }
                    }
                }
            }
        }
        if errors.isEmpty{
            passed = true
        }
    }
    
    
    
    
}

//a bunch of functions to complement the validation class above
func validatedPassword(password : String) -> Bool {
    let validation = Validation()
    let textFields = ["password": password]
    validation.check(textFields, items: [
        "password" : ["required": true, "min": 6, "max": 20]
        ])
    if (!validation.passed) {
        //validation failed
        return false
    } else {
        return true
    }
}

func validatedPhoneNumber(phoneNumber: String) -> Bool {
    let validation = Validation()
    let textFields = ["phonenum": phoneNumber]
    validation.check(textFields, items: ["phonenum" : ["required": true, "lengthEqualTo": 10]
        ])
    //if it's the right length, check for numeric chars only
    for c in phoneNumber.characters {
        if(c < "0" || c > "9") {
            logError("Invalid digit in phone number string.")
            validation.passed = false;
            break;
        }
    }
    if(!validation.passed) {
        //validation failed
        print(validation.errors)
        return false
    } else {
        return true
    }
}

func validatedEmail(email: String) -> Bool {
    if(emailStringFilter(email)){
        return true
    } else {
        //validation failed
        logError("Invalid email in verification step.")
        return false
    }
}

func emailStringFilter(email: String) -> Bool {
    //a bit of Objective-C to do regex
    let filterString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", filterString)
    return emailTest.evaluateWithObject(email)
}

func validatedUsername(username: String) -> Bool {
    let validation = Validation()
    let textFields = ["username": username]
    validation.check(textFields, items: [
        "username" : ["required": true, "min": 4, "max": 20]
        ])
    if (!validation.passed || usernameExistsInParse(username)) {
        //validation failed
        logError(validation.errors)
        return false
    } else {
        return true
    }
}

func usernameExistsInParse(username: String) -> Bool {
    // Synchronous and is skipped by iOS as a long-running blocking function
    let query: PFQuery = PFUser.query()!
    var usernameExists = true
    query.whereKey("username", equalTo: username)
    do {
        let results: [PFObject] = try query.findObjects()
        if results.count > 0 {
            logError("Username already exists.")
            usernameExists = true
        } else {
            usernameExists = false
        }
    } catch {
        logError("\(error)")
    }
    return usernameExists
}

func logError(error: AnyObject) {
    NSLog("ERROR:\n\(error)")
    
    // Send notification
    if let tempUser = PFUser.currentUser() {
        let notification = Notification(content: "\nERROR:\n\(error)", sendToID: (tempUser.objectId)!)
        notification.push()
    }
    
}

func showBadInputWarningInField(field: UITextField) {
    // Called when the text in the param of type UITextField is invalid.
    let border = CALayer()
    let redColor = UIColor.redColor()
    addThickBorderToTextField(border, field: field, color: redColor)
}

func showGoodInputInField(field: UITextField) {
    // Called when the text in the param of type UITextField is valid.
    let border = CALayer()
    let normalColor = UIColor.lightGrayColor()
    addBorderToTextField(border, field: field, color: normalColor)
}

func createBorder(layer: CALayer, borderWidth: Double, color: UIColor) -> CALayer? {
    let borderWidthL = CGFloat(borderWidth)
    layer.borderColor = color.CGColor
    layer.borderWidth = borderWidthL
    return layer
}

func addBorderToTextField(layer: CALayer,field: UITextField, color: UIColor) {
    let bw = 0.5
    //create the bottom border and add to the sublayer
    field.layer.addSublayer(createBorder(layer, borderWidth: bw, color: color)!)
    field.layer.masksToBounds = true
    layer.frame = CGRect(x: 0, y: field.frame.height - 1.0, width: field.frame.width , height: field.frame.height - 1.0)
}

func addThickBorderToTextField(layer: CALayer,field: UITextField, color: UIColor) {
    let bw = 2.0
    //create the bottom border and add to the sublayer
    field.layer.addSublayer(createBorder(layer, borderWidth: bw, color: color)!)
    field.layer.masksToBounds = true
    layer.frame = CGRect(x: 0, y: field.frame.height - 1.0, width: field.frame.width , height: field.frame.height - 1.0)
}