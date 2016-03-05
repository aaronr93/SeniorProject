//
//  InterfaceManipulations.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 3/5/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import UIKit

class InterfaceManipulation {
    func setCustomerStyleFor(button: UIButton, toReflect currentStatus: OrderState) {
        if currentStatus == OrderState.Available {
            customer_setCancelStyleFor(button)
        } else if currentStatus == OrderState.Acquired {
            customer_setAcquiredStyleFor(button)
        } else if currentStatus == OrderState.Deleted {
            customer_setDeletedStyleFor(button)
        } else if currentStatus == OrderState.PaidFor {
            customer_setPaidForStyleFor(button)
        } else if currentStatus == OrderState.Delivered {
            customer_setDeliveredStyleFor(button)
        } else if currentStatus == OrderState.Completed {
            customer_setCompletedStyleFor(button)
        }
    }
    
    func setDriverStyleFor(button: UIButton, toReflect currentStatus: OrderState) {
        if currentStatus == OrderState.Available {
            driver_setIllGetThatStyleFor(button)
        } else if currentStatus == OrderState.Acquired {
            driver_setPayForStyleFor(button)
        } else if currentStatus == OrderState.PaidFor {
            driver_setDeliveredStyleFor(button)
        } else if currentStatus == OrderState.Completed {
            driver_setCompletedStyleFor(button)
        }
    }
    
    func customer_setCancelStyleFor(button: UIButton) {
        button.titleLabel?.text = "Cancel"
        button.titleLabel?.textColor = UIColor.redColor()
        button.enabled = true
    }
    
    func customer_setAcquiredStyleFor(button: UIButton) {
        button.titleLabel?.textColor = UIColor.grayColor()
        button.titleLabel?.text = "Acquired by driver"
        button.enabled = false
    }
    
    func customer_setDeletedStyleFor(button: UIButton) {
        button.titleLabel?.textColor = UIColor.grayColor()
        button.titleLabel?.text = "Order deleted"
        button.enabled = false
    }
    
    func customer_setPaidForStyleFor(button: UIButton) {
        let blueColor = UIColor(colorLiteralRed: 13, green: 95, blue: 250, alpha: 1)
        button.titleLabel?.textColor = blueColor
        button.titleLabel?.text = "Order paid for by driver"
        button.enabled = false
    }
    
    func customer_setDeliveredStyleFor(button: UIButton) {
        let blueColor = UIColor(colorLiteralRed: 13, green: 95, blue: 250, alpha: 1)
        button.titleLabel?.textColor = blueColor
        button.titleLabel?.text = "Reimburse driver"
        button.enabled = true
    }
    
    func customer_setCompletedStyleFor(button: UIButton) {
        button.titleLabel?.textColor = UIColor.grayColor()
        button.titleLabel?.text = "Order completed"
        button.enabled = false
    }
    
    // Driver
    
    func driver_setIllGetThatStyleFor(button: UIButton) {
        button.titleLabel?.text = "I'll get that"
    }
    
    func driver_setAcquiredStyleFor(button: UIButton) {
        button.titleLabel?.text = "Acquired ✓"
    }
    
    func driver_setPayForStyleFor(button: UIButton) {
        button.titleLabel?.text = "I paid for the food"
    }
    
    func driver_setDeliveredStyleFor(button: UIButton) {
        button.titleLabel?.text = "I arrived at the delivery location"
    }
    
    func driver_setCompletedStyleFor(button: UIButton) {
        button.titleLabel?.textColor = UIColor.grayColor()
        button.titleLabel?.text = "Order completed"
        button.enabled = false
    }
}