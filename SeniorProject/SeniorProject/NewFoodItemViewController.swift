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

class NewFoodItemViewController: UIViewController, UITextFieldDelegate{

    var delegate : NewOrderViewController!
    
    @IBOutlet weak var foodName: UITextField!
    @IBOutlet weak var foodDescription: UITextField!
    
    var foodNameText = ""
    var foodDescriptionText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        foodName.delegate = self
        foodDescription.delegate = self
        
        foodName.becomeFirstResponder()
        
        foodName.returnKeyType = UIReturnKeyType.Next
        foodDescription.returnKeyType = UIReturnKeyType.Done
    }
    
    @IBAction func addFoodItem(sender: UIButton) {
        foodNameText = foodName.text!
        foodDescriptionText = foodDescription.text!
        delegate.saveNewItem(self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == foodName { // Switch focus to other text field
            foodDescription.becomeFirstResponder()
        }else if textField == foodDescription{
            foodDescription.resignFirstResponder()
            delegate.saveNewItem(self)
        }
        return true
    }
    
    
    
}
