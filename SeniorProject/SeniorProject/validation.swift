//
//  validation.swift
//  SeniorProject
//
//  Created by Michael Kytka on 2/1/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation

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