//
//  NewFoodItemViewController.swift
//  SeniorProject
//
//  Created by Seth Loew on 3/3/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse

class NewFoodItemViewController: UIViewController {

    @IBOutlet weak var foodName: UITextField!
    @IBOutlet weak var foodDescription: UITextField!
    var parent = NewOrderViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
