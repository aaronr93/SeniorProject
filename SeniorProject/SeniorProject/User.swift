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
    var username: String
    var name: String?
    var email: String?
    var phone: String?
    var location: String? // Possibly change this to something tied to Apple 
    // Password?
    // Picture
    
    init(userID: String, username: String) {
        self.userID = userID
        self.username = username
    }
}
