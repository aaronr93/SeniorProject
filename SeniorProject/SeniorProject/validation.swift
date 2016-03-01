//
//  validation.swift
//  SeniorProject
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

class Validation
{
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
func validatedPassword(passedField: UITextField) -> Bool {
    let validation = Validation()
    if let fieldText = passedField.text {
        let textFields = ["password": fieldText]
        validation.check(textFields, items: [
            "password" : ["required": true, "min": 6, "max": 20]
            ])
    }
    if (!validation.passed) {
        //validation failed
        print(validation.errors)
        showBadInputWarningInField(passedField)
        return false
    } else {
        showGoodInputInField(passedField)
        return true
    }
}

func validatedPhoneNumber(passedField: UITextField) -> Bool {
    let validation = Validation()
    if let fieldText = passedField.text {
        let textFields = ["phonenum": fieldText]
        validation.check(textFields, items: ["phonenum" : ["required": true, "lengthEqualTo": 10]
            ])
        //if it's the right length, check for numeric chars only
        for c in fieldText.characters {
            if(c < "0" || c > "9") {
                print("invalid digit in phone number string")
                validation.passed = false;
                break;
            }
        }
    }
    if(!validation.passed) {
        //validation failed
        print(validation.errors)
        showBadInputWarningInField(passedField)
        return false
    } else {
        showGoodInputInField(passedField)
        return true
    }
}

func validatedEmail(passedField: UITextField) -> Bool {
    if let fieldText = passedField.text {
        if(emailStringFilter(fieldText)){
            showGoodInputInField(passedField)
            return true
        } else {
            //validation failed
            print("invalid email in verification step.")
            showBadInputWarningInField(passedField)
            return false
        }
    } else {//let check failed
        print("email text field not valid.")
        showBadInputWarningInField(passedField)
        return false
    }
}

func emailStringFilter(email: String) -> Bool {
    //a bit of Objective-C to do regex
    let filterString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", filterString)
    return emailTest.evaluateWithObject(email)
}

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

func validatedUsername(passedField: UITextField) -> Bool {
    let validation = Validation()
    if let fieldText = passedField.text {
        let textFields = ["username": fieldText]
        validation.check(textFields, items: [
            "username" : ["required": true, "min": 4, "max": 20]
            ])
    }
    if (!validation.passed || usernameExistsInParse(passedField)) {
        //validation failed
        print(validation.errors)
        showBadInputWarningInField(passedField)
        return false
    } else {
        showGoodInputInField(passedField)
        return true
    }
}

func usernameExistsInParse(uNameField: UITextField) -> Bool {
    // Synchronous and is skipped by iOS as a long-running blocking function
    let query: PFQuery = PFUser.query()!
    var usernameExists = true
    query.whereKey("username", equalTo: uNameField.text!)
    do {
        let results: [PFObject] = try query.findObjects()
        print(results.count)
        if results.count > 0 {
            print("Username already exists.")
            usernameExists = true
        } else {
            usernameExists = false
        }
    } catch {
        print(error)
    }
    return usernameExists
}



