//
//  ExpiresInViewController.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/2/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit

class ExpiresInViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var timePicker : UIPickerView!
    let timePickerData = ["15 Minutes", "30 Minutes", "1 Hour", "2 Hours"]
    var selectedTime = "15 Minutes"
    
    var newOrderDelegate: NewOrderViewController!
    var driverRestaurantDelegate: DriverRestaurantsViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.dataSource = self
        timePicker.delegate = self
        timePicker.selectRow(timePickerData.indexOf(selectedTime)!, inComponent: 0, animated: false)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timePickerData.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timePickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTime = timePickerData[row]
    }
    
    override func viewWillDisappear(animated: Bool) {
        if newOrderDelegate != nil {
            newOrderDelegate.order.expiresIn = selectedTime
            newOrderDelegate.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 2)], withRowAnimation: .Automatic)
        }
        if driverRestaurantDelegate != nil {
            driverRestaurantDelegate.prefs.availability!.expirationDate = getActualTimeFromNow()
            driverRestaurantDelegate.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: .Automatic)
        }
    }
    
    func getActualTimeFromNow() -> NSDate {
        let now = NSDate()
        
        switch selectedTime {
            case "15 minutes":
                let calendar = NSCalendar.currentCalendar()
                let date = calendar.dateByAddingUnit(.Minute, value: 15, toDate: now, options: [])
                return date!
            case "30 minutes":
                let calendar = NSCalendar.currentCalendar()
                let date = calendar.dateByAddingUnit(.Minute, value: 30, toDate: now, options: [])
                return date!
            case "1 hour":
                let calendar = NSCalendar.currentCalendar()
                let date = calendar.dateByAddingUnit(.Hour, value: 1, toDate: now, options: [])
                return date!
            case "2 hours":
                let calendar = NSCalendar.currentCalendar()
                let date = calendar.dateByAddingUnit(.Hour, value: 2, toDate: now, options: [])
                return date!
            case "3 hours":
                let calendar = NSCalendar.currentCalendar()
                let date = calendar.dateByAddingUnit(.Hour, value: 3, toDate: now, options: [])
                return date!
            case "4 hours":
                let calendar = NSCalendar.currentCalendar()
                let date = calendar.dateByAddingUnit(.Hour, value: 4, toDate: now, options: [])
                return date!
            default:
                let calendar = NSCalendar.currentCalendar()
                let date = calendar.dateByAddingUnit(.Hour, value: 1, toDate: now, options: [])
                return date!
        }
    }

}
