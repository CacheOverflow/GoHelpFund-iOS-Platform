//
//  OnboardingStepPassword.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 11/13/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class OnboardingStepPassword: NibView {
    var vm: OnboardingVM
    
    @IBOutlet var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var passwordLabel: UILabel!
    
    init(vm: OnboardingVM) {
        self.vm = vm
        super.init(frame: CGRect.zero)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        passwordTextField.placeholder = "Password"
    }
    
    override var isValidStep: Bool {
        vm.updateWithPassword(password: passwordTextField.text)
        return true
    }
}
