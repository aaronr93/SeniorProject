//
//  CustomDeliveryLocationTableViewCell.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 3/7/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit

protocol CustomDeliveryLocationDelegate {}

class CustomDeliveryLocationTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var customField: UITextField!
    var delegate: DeliveryLocationTableViewController!
    
    @IBAction func add(sender: UIButton) {
        let newDest = customField.text!
        
        if newDest != "" {
            delegate.dest.addDestinationItemToDB(newDest) { result in
                if result {
                    self.delegate.tableView.reloadData()
                    let index = self.delegate.dest.history.count
                    self.delegate.tableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 1), animated: true, scrollPosition: .Bottom)
                } else {
                    logError("Adding custom destination was unsuccessful")
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customField.delegate = self
    }

}
