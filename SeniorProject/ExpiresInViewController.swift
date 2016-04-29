//
//  ExpiresInViewController.swift
//  Foodini
//
//  Created by Zach Nafziger on 3/2/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
}

class ExpiresInViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var timePicker: UIPickerView!
    var timePickerData = [[String](), [String]()];
    var selectedHours = 0
    var selectedMinutes = 0
    
    var hours = 6
    var numberOfMinuteIntervals = 4
    
    var newOrderDelegate: NewOrderViewController!
    var driverRestaurantDelegate: DriverRestaurantsViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for hour in 0...hours{
            if hour == 1{
                timePickerData[0].append("\(hour) hour")
            }else{
                timePickerData[0].append("\(hour) hours")
            }
        }
        
        let minutesInHour = 60
        
        let minuteInterval = minutesInHour/numberOfMinuteIntervals
        
        var minutes = 0
        
        for _ in 1...numberOfMinuteIntervals{
            timePickerData[1].append("\(minutes) minutes")
            minutes = (minutes + minuteInterval) % minutesInHour
        }
        
        
        timePicker.dataSource = self
        timePicker.delegate = self
        
        let selectedHourRow = selectedHours
        
        let selectedMinuteRow = selectedMinutes / minuteInterval
        
        timePicker.selectRow(selectedHourRow, inComponent: 0, animated: false)
        timePicker.selectRow(selectedMinuteRow, inComponent: 1, animated: false)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return timePickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timePickerData[component].count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timePickerData[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedHoursString = timePickerData[0][timePicker.selectedRowInComponent(0)]
        let selectedMinutesString = timePickerData[1][timePicker.selectedRowInComponent(1)]
        
        let hoursSplit = selectedHoursString.characters.split{$0 == " "}.map(String.init)
        let minutesSplit = selectedMinutesString.characters.split{$0 == " "}.map(String.init)
        
        selectedHours = Int(hoursSplit[0])!
        selectedMinutes = Int(minutesSplit[0])!
    }
    
    override func viewWillDisappear(animated: Bool) {
        if newOrderDelegate != nil {
            if selectedHours != 0 || selectedMinutes != 0 {
                newOrderDelegate.order.expiresMinutes = selectedMinutes
                newOrderDelegate.order.expiresHours = selectedHours
                newOrderDelegate.order.expiresIn = "\(selectedHours) hours \(selectedMinutes) minutes"
                newOrderDelegate.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 2)], withRowAnimation: .Automatic)
            }
        }
        if driverRestaurantDelegate != nil {
            driverRestaurantDelegate.prefs.availability!.expirationDate = getActualTimeFromNow()
            
            let selectedHoursString = timePickerData[0][timePicker.selectedRowInComponent(0)]
            let selectedMinutesString = timePickerData[1][timePicker.selectedRowInComponent(1)]
            let time = selectedHoursString + " " + selectedMinutesString
            
            if selectedHoursString != "0 hours" || selectedMinutesString != "0 minutes" {
                driverRestaurantDelegate.prefs.selectedExpirationTime = time
                driverRestaurantDelegate.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0),
                    NSIndexPath(forRow: 0, inSection: 0)],
                    withRowAnimation: .None)
            }
        }
    }
    
    func getActualTimeFromNow() -> NSDate {
        let now = NSDate()
        
        let totalMinutes = (selectedHours * 60) + selectedMinutes
        
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(.Minute, value: totalMinutes, toDate: now, options: [])
        return date!
    }

}
