//
//  OnboardingStepFullName.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 11/15/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class OnboardingStepFullName: NibView {
    var vm: OnboardingVM
    
    @IBOutlet var fullNameTextField: SkyFloatingLabelTextFieldWithIcon!
    
    init(vm: OnboardingVM) {
        self.vm = vm
        super.init(frame: CGRect.zero)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isValidStep: Bool {
        vm.updateWithFullName(fullName: fullNameTextField.text)
        return true
    }
}
