//
//  Destination.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 3/7/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import Parse

class Destination {
    var name: String
    var loc: PFGeoPoint?
    var id: String
    
    init() {
        self.name = ""
        self.id = ""
    }
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
}