//
//  Restaurant.swift
//  Foodini
//
//  Created by Aaron Rosenberger on 3/17/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import Parse

class Restaurant: NSObject {
    var name: String
    var loc: PFGeoPoint?
    var dist: Double?
    
    init(name: String) {
        self.name = name
    }
}