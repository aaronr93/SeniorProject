//
//  InterfaceManipulations.swift
//  Foodini
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
        } else if currentStatus == OrderState.Delivered {
            driver_setWaitStyleFor(button)
        } else if currentStatus == OrderState.Completed {
            driver_setCompletedStyleFor(button)
        }
    }
    
    func customer_setCancelStyleFor(button: UIButton) {
        button.setTitle("Cancel", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        button.enabled = true
    }
    
    func customer_setAcquiredStyleFor(button: UIButton) {
        button.setTitle("Acquired by driver", forState: UIControlState.Disabled)
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        button.enabled = false
    }
    
    func customer_setDeletedStyleFor(button: UIButton) {
        button.setTitle("Order deleted", forState: UIControlState.Disabled)
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        button.enabled = false
    }
    
    func customer_setPaidForStyleFor(button: UIButton) {
        button.setTitle("Order paid for by driver", forState: UIControlState.Disabled)
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        button.enabled = false
    }
    
    func customer_setDeliveredStyleFor(button: UIButton) {
        button.setTitle("Reimburse driver", forState: UIControlState.Normal)
        button.enabled = true
    }
    
    func customer_setCompletedStyleFor(button: UIButton) {
        button.setTitle("Order completed", forState: UIControlState.Disabled)
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        button.enabled = false
    }
    
    // Driver
    
    func driver_setIllGetThatStyleFor(button: UIButton) {
        button.setTitle("I'll get that", forState: UIControlState.Normal)
        button.enabled = true
    }
    
    func driver_setAcquiredStyleFor(button: UIButton) {
        button.setTitle("Acquired ✓", forState: UIControlState.Disabled)
        button.enabled = false
    }
    
    func driver_setPayForStyleFor(button: UIButton) {
        button.setTitle("I paid for the food", forState: UIControlState.Normal)
        button.enabled = true
    }
    
    func driver_setDeliveredStyleFor(button: UIButton) {
        button.setTitle("I arrived at the delivery location", forState: UIControlState.Normal)
        button.enabled = true
    }
    
    func driver_setWaitStyleFor(button: UIButton) {
        button.setTitle("Waiting for customer to reimburse", forState: UIControlState.Disabled)
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        button.enabled = false
    }
    
    func driver_setCompletedStyleFor(button: UIButton) {
        button.setTitle("Order completed", forState: UIControlState.Disabled)
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        button.enabled = false
    }
}