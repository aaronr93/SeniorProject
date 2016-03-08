//
//  NewFoodItemViewController.swift
//  SeniorProject
//
//  Created by Seth Loew on 3/3/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

protocol NewFoodItemViewDelegate {
    func cancelNewItem(newOrderVC: NewFoodItemViewController)
    func saveNewItem(newOrderVC: NewFoodItemViewController)
}

class NewFoodItemViewController: UIViewController, UITextFieldDelegate {

    var delegate : NewOrderViewController!
    
    @IBOutlet weak var foodDescriptionField: UITextField!
    @IBOutlet weak var foodNameField: UITextField!
    
    var foodNameText = ""
    var foodDescriptionText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        foodNameField.delegate = self
        foodDescriptionField.delegate = self
        
        foodNameField.becomeFirstResponder()
        
        foodNameField.returnKeyType = UIReturnKeyType.Next
        foodDescriptionField.returnKeyType = UIReturnKeyType.Done
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == foodNameField { // Switch focus to other text field
            foodDescriptionField.becomeFirstResponder()
        }else if textField == foodDescriptionField{
            foodDescriptionField.resignFirstResponder()
            foodNameText = foodNameField.text!
            foodDescriptionText = foodDescriptionField.text!
            if foodNameText.isEmpty{
                delegate.cancelNewItem(self)
                return true
            }
            delegate.saveNewItem(self)
        }
        return true
    }
    
    
    
}
