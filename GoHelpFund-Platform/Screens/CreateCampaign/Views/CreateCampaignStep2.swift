//
//  CreateCampaignStep3.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 8/8/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import UITextView_Placeholder

class CreateCampaignStep2: NibView {
    @IBOutlet var amountNeededTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var expensesDescriptionTextView: UITextView!
    
    override init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        expensesDescriptionTextView.layer.borderWidth = 1
        expensesDescriptionTextView.layer.borderColor = UIColor.black.cgColor
        
        amountNeededTextField.delegate = self
    }
    
    var amount: String? {
        return amountNeededTextField.text
    }
    
    var descriptionExpense: String {
        return expensesDescriptionTextView.text
    }
    
    func isAmountValid() -> Bool {
        return (amount ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isNumber
    }
    
    override var isValidStep: Bool {
        if !isAmountValid() && descriptionExpense.isEmpty {
            handleUnvalidState(invalidFields: .titleAndDescription)
            return false
        } else if !isAmountValid() {
            handleUnvalidState(invalidFields: .title)
            return false
        } else if descriptionExpense.isEmpty {
            handleUnvalidState(invalidFields: .description)
            return false
        } else {
            return true
        }
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
        amountNeededTextField.errorMessage = "Amount needed is required"
        amountNeededTextField.text = ""
    }
    
    func invalidDescription() {
        expensesDescriptionTextView.placeholderColor = .red
        expensesDescriptionTextView.placeholder = "Expenses description is required"
    }
}

extension CreateCampaignStep2: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        amountNeededTextField.errorMessage = ""
        return true
    }
}
