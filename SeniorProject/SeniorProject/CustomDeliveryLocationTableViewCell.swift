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
        let newDest = Destination(name: customField.text!)
        delegate.dest.addDestinationItemToDB(newDest)
        delegate.dest.add(newDest)
        delegate.tableView.reloadData()
        delegate.deliveryLocation = newDest.name!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customField.delegate = self
    }

}
