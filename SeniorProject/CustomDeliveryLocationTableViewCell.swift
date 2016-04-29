//
//  CustomDeliveryLocationTableViewCell.swift
//  Foodini
//
//  Created by Aaron Rosenberger on 3/7/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit

protocol CustomDeliveryLocationDelegate {}

class CustomDeliveryLocationTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var customField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var delegate: DeliveryLocationTableViewController!
    
    @IBAction func add(sender: UIButton) {
        started()
        let newDest = customField.text!
        if newDest != "" {
            delegate.dest.add(newDest) { success in
                self.finished()
                self.delegate.tableView.performSelectorOnMainThread(#selector(UITableView.reloadData), withObject: nil, waitUntilDone: true)
            }
        }
    }
    
    func started() {
        activity.startAnimating()
        addButton.hidden = true
        customField.enabled = false
    }
    
    func finished() {
        activity.stopAnimating()
        customField.enabled = true
        customField.text = ""
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        addButton.hidden = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customField.delegate = self
    }

}
