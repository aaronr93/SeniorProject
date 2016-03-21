//
//  NewFoodItemTableViewController.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 3/18/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

protocol NewFoodItemViewDelegate {
    func cancelNewItem(newOrderVC: NewFoodItemTableViewController)
    func saveNewItem(newOrderVC: NewFoodItemTableViewController)
    func editNewItem(newOrderVC: NewFoodItemTableViewController)
}

class NewFoodItemTableViewController: UITableViewController, UITextFieldDelegate {
    
    var delegate: NewOrderViewController!
    
    var foodNameText = ""
    var foodDescriptionText = ""
    var index: Int?
    
    @IBOutlet weak var foodNameField: UITextField!
    @IBOutlet weak var foodDescriptionField: UITextField!
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        delegate.cancelNewItem(self)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        sendFoodItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodNameField.delegate = self
        foodDescriptionField.delegate = self
        
        if !foodNameText.isEmpty {
            foodNameField.text = foodNameText
        }
        
        if !foodDescriptionText.isEmpty {
            foodDescriptionField.text = foodDescriptionText
        }
        
        foodNameField.becomeFirstResponder()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        foodDescriptionField.resignFirstResponder()
        foodNameField.resignFirstResponder()
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == foodNameField { // Switch focus to other text field
            foodDescriptionField.becomeFirstResponder()
        } else if textField == foodDescriptionField {
            foodDescriptionField.resignFirstResponder()
            return sendFoodItem()
        }
        return true
    }
    
    func sendFoodItem() -> Bool {
        foodNameText = foodNameField.text!
        foodDescriptionText = foodDescriptionField.text!
        
        if (index != nil) {
            delegate.editNewItem(self)
            return true
        }
        if foodNameText.isEmpty {
            delegate.cancelNewItem(self)
            return true
        }
        delegate.saveNewItem(self)
        return true
    }

}
