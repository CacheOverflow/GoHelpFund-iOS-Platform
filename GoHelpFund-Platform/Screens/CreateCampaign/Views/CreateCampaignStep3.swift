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

class CreateCampaignStep3: NibView {
    @IBOutlet var startDateTextField: SkyFloatingLabelTextField!
    @IBOutlet var endDateTextField: SkyFloatingLabelTextField!
    @IBOutlet var locationTextField: SkyFloatingLabelTextField!
    
    var startDate: Date? = nil
    var endDate: Date? = nil
    
    var location: String? {
        guard let location = locationTextField.text else { return nil }
        if location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return nil }
        return location
    }
    
    let delegate: CreateCampaignStep2Delegate?
    
    init(delegate: CreateCampaignStep2Delegate) {
        self.delegate = delegate
        
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func presentCalendar(with tag: Int) {
        let min = Date().addingTimeInterval(-6000 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(6000 * 60 * 24 * 4)
        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        picker.isDatePickerOnly = true
        
        picker.includeMonth = true
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.darkColor = .darkGray
        picker.doneButtonTitle = "DONE"
        picker.doneBackgroundColor = UIColor.greenHelp
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/YYYY"
            
            if let fieldsEnum = TextFieldType(rawValue: tag) {
                switch fieldsEnum {
                case .startDate:
                    self.startDateTextField.text = formatter.string(from: date)
                    self.startDateTextField.errorMessage = ""
                    self.startDate = date
                case .endDate:
                    self.endDateTextField.text = formatter.string(from: date)
                    self.endDateTextField.errorMessage = ""
                    self.endDate = date
                case .location:
                    break
                }
            }
        }
    
        picker.show()
    }
    
    func update(with location: String) {
        locationTextField.text = location
        locationTextField.errorMessage = ""
    }
    
    override var isValidStep: Bool {
        var valid = true
        if startDate == nil {
            invalidStartDate()
            valid = false
        }
        if endDate == nil {
            invalidEndDate()
            valid = false
        }
        if location == nil {
            invalidLocation()
            valid = false
        }
        return valid
    }
    
    func invalidStartDate() {
        startDateTextField.errorMessage = "Start date is required"
    }

    func invalidEndDate() {
        endDateTextField.errorMessage = "End date is required"
    }
    
    func invalidLocation() {
        locationTextField.errorMessage = "Location is required"
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
