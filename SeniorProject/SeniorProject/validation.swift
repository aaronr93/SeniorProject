//
//  validation.swift
//  SeniorProject
//
//  Created by Michael Kytka on 2/1/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation

class Validation
{
    var errors = [String]()
    var passed : Bool = false
    
    func check(values: [String], items: [String : [String : AnyObject]]){
        for item in items {
            print(item)
        }
    }
}