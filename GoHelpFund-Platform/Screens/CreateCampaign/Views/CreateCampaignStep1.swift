//
//  CreateCampaignStep1.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 8/8/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import GrowingTextView

class CreateCampaignStep1: NibView {
    @IBOutlet var titleTextField: SkyFloatingLabelTextField!
    @IBOutlet var descriptionTextView: GrowingTextView!
    
    
    override init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        titleTextField.delegate = self
        titleTextField.placeholder = "Titleee"
    }
    
    var title: String? {
        return titleTextField.text
    }
    
    var descriptionCampaign: String? {
        return descriptionTextView.text
    }
    
    var isValidStep: Bool {
        guard let _ = title, let _ = descriptionCampaign else { return false }
        return true
    }
}

extension CreateCampaignStep1: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

