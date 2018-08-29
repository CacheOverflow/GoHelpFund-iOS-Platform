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
import GooglePlaces

enum TextFieldType: Int {
    case startDate = 1
    case endDate = 2
    case location = 3
}

protocol CreateCampaignStep2Delegate {
    func didTapLocation()
}

class CreateCampaignStep3: NibView, DateTimePickerDelegate {
    @IBOutlet var startDateTextField: SkyFloatingLabelTextField!
    
    @IBOutlet var endDateTextField: SkyFloatingLabelTextField!
    
    @IBOutlet var locationTextField: SkyFloatingLabelTextField!
    
    let delegate: CreateCampaignStep2Delegate?
    
    init(delegate: CreateCampaignStep2Delegate) {
        self.delegate = delegate
        
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            
            if let fieldsEnum = TextFieldType(rawValue: tag) {
                switch fieldsEnum {
                case .startDate:
                    self.startDateTextField.text = formatter.string(from: date)
                case .endDate:
                    self.endDateTextField.text = formatter.string(from: date)
                case .location:
                    break
                }
            }
        }
        
        picker.delegate = self
        
        picker.show()
    }
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        
    }
    
    func update(with location: String) {
        locationTextField.text = location
    }
}

extension CreateCampaignStep3: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let fieldsEnum = TextFieldType(rawValue: textField.tag) {
            if fieldsEnum == .location {
                delegate?.didTapLocation()
            } else {
                presentCalendar(with: textField.tag)
            }
            
        }
        
        return false
    }
}
    
extension CreateCampaignStep3 {
    var isValidStep: Bool {
        return true
    }
}
