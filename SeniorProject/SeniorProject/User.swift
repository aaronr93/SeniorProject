//
//  User.swift
//  SeniorProject
//
//  Created by Michael Kytka on 1/25/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation


class User
{
    var userID: String
    var email: String?
    var phone: String?
    var location: String? // Possibly change this to something tied to Apple 
    // Password?
    
    init(userID: String) {
        self.userID = userID
    }
}

class Settings
{
    var active: Bool
    
    init(active: Bool) {
        self.active = active
    }
}