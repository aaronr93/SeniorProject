//
//  Order.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/12/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import Parse

class Order {
    
    var deleted: Bool?
    var delivered: Bool?
    var driverToDeliver: PFUser?
    var isAnyDriver: Bool?
    var DeliveryState: String?
    var DeliveryZip: String?
    var DeliveryAddress: String?
    var expirationDate: NSDate?
    var timeDelivered: NSDate?
    var OrderingUser: PFUser?
    var createdAt: NSDate?
    var timeSent: NSDate?
    var restaurant: Restaurant?
    var deliveredBy: NSDate?
    var deliveryLocation: String?
    var expireTime: NSDate?
}