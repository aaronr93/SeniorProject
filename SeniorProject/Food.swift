//
//  Food.swift
//  Foodini
//
//  Created by Michael Kytka on 3/6/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation

class Food {
    var description: String?
    var name: String?
    
    init(name: String?, description: String?) {
        self.name = name
        self.description = description
    }
}