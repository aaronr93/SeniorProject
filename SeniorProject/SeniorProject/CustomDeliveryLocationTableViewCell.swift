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
        let newDest = Destination(name: customField.text!, id: nil)
        delegate.dest.addDestinationItemToDB(newDest, completion: {
            (success, id) in
            if success{
                newDest.id = id
                self.delegate.dest.add(newDest)
                self.delegate.tableView.reloadData()
                self.delegate.deliveryLocation = newDest.name!
            }else{
                print("add unsuccessful")
            }
        })
            }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customField.delegate = self
    }

}
