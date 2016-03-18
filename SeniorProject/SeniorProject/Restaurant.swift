//
//  Restaurant.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 3/17/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import MapKit

class Restaurant: NSObject {
    var name: String
    var loc: MKPlacemark
    
    init(name: String, loc: MKPlacemark) {
        self.name = name
        self.loc = loc
    }
}