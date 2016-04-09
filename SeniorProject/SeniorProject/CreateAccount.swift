//
//  CreateAccount.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/5/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation

class CreateAccount {
    var username: String?
    var password: String?
    var passwordConfirm: String?
    var email: String?
    var phone: String?
    var isValidated: Bool = false
    
    func checkPasswordIsNotHorrible() -> Bool {
        if username != nil && password != nil {
            if password!.containsString(username!) {
                // username is contained in the password
                return false
            }
            if (password!.containsString("password")) {
                // The user tried to set the password as "password"
                return false
            }
            return true
        }
        return false
    }
    
    func confirmPasswordEqualsPassword() -> Bool {
        if (passwordConfirm == password && password != nil) {
            return true
        } else {
            return false
        }
    }
    
}