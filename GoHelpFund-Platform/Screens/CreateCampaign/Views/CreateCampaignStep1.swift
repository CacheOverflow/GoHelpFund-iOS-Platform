//
//  CreateCampaignStep1.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 8/8/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import UITextView_Placeholder

enum InvalidFields {
    case title
    case description
    case titleAndDescription
}

class CreateCampaignStep1: NibView {
    @IBOutlet var titleTextField: SkyFloatingLabelTextField!
    @IBOutlet var descriptionTextView: UITextView!
    var vm: CreateCampaignVM
    //step1VM
    //observe
    
    init(vm: CreateCampaignVM) {
        self.vm = vm
        super.init(frame: CGRect.zero)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init not implemented")
    }
    
    private func setup() {
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        
        titleTextField.delegate = self
        descriptionTextView.delegate = self
    }
    
    var title: String? {
        return titleTextField.text
    }
    
    var descriptionCampaign: String {
        return descriptionTextView.text
    }
    
    override var isValidStep: Bool {
        if !isValidTitle() && !isValidDescription() {
            handleUnvalidState(invalidFields: .titleAndDescription)
            return false
        } else if !isValidTitle() {
            handleUnvalidState(invalidFields: .title)
            return false
        } else if !isValidDescription() {
            handleUnvalidState(invalidFields: .description)
            return false
        } else {
            //valid step => we can extract the valid data
            if let title = title {
                vm.updateForStep1(title: title, description: description)
            }
            return true
        }
    }
    
    func isValidTitle() -> Bool {
        let nonOptionalTitle = title ?? ""
        return !(nonOptionalTitle.isEmpty) && nonOptionalTitle.containsNonWhitespace
    }
    
    func isValidDescription() -> Bool {
        return !(descriptionCampaign.isEmpty) && descriptionCampaign.containsNonWhitespace
    }
    
    func handleUnvalidState(invalidFields: InvalidFields) {
        switch invalidFields {
        case .titleAndDescription:
            invalidTitle()
            invalidDescription()
        case .title:
            invalidTitle()
        case .description:
            invalidDescription()
        }
    }
    
    func invalidTitle() {
        titleTextField.errorMessage = "Title is required"
        titleTextField.text = ""
    }
    
    func invalidDescription() {
        descriptionTextView.placeholderColor = .red
        descriptionTextView.placeholder = "Description is required"
    }
}

extension CreateCampaignStep1: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        titleTextField.errorMessage = ""
        return true
    }
}

extension CreateCampaignStep1: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}

