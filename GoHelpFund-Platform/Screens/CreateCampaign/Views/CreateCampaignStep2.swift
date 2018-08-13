//
//  CreateCampaignStep2.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 8/8/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit
import DateTimePicker
import SkyFloatingLabelTextField

enum TextFieldType: Int {
    case startDate = 1
    case endDate = 2
}

class CreateCampaignStep2: NibView, DateTimePickerDelegate {
    @IBOutlet var startDateTextField: SkyFloatingLabelTextField!
    
    @IBOutlet var endDateTextField: SkyFloatingLabelTextField!
    
    var startDate: Date {
        return Date()
    }
    
    var endDate: Date {
        return Date()
    }
    
    @IBAction func didBeginEditing(_ sender: Any) {
        
    }
    
    func presentCalendar(with tag: Int) {
        let min = Date().addingTimeInterval(-600 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(600 * 60 * 24 * 4)
        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        picker.isDatePickerOnly = true
        
        picker.includeMonth = true // if true the month shows at bottom of date cell
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "DONE"
        picker.doneBackgroundColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
            if tag == TextFieldType.startDate.rawValue {
                self.startDateTextField.text = formatter.string(from: date)
            } else {
                self.endDateTextField.text = formatter.string(from: date)
            }
            
        }
        picker.delegate = self
        
        picker.show()
    }
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        
    }
}

extension CreateCampaignStep2: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        presentCalendar(with: textField.tag)
        return false
    }
}

extension CreateCampaignStep2 {
    var isValidStep: Bool {
        return true
    }
}
