//
//  OnboardingStepEmail.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 11/13/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class OnboardingStepEmail: NibView {
    var vm: OnboardingVM
    
    @IBOutlet var EnterEmailMotivationLabel: UILabel!
    @IBOutlet var emailTextField: SkyFloatingLabelTextField!
    
    init(vm: OnboardingVM) {
        self.vm = vm
        super.init(frame: CGRect.zero)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        emailTextField.placeholder = "Email"
        emailTextField.lineColor = .white
        emailTextField.selectedLineColor = .red
    }
    
    override var isValidStep: Bool {
        vm.updateWithEmail(email: emailTextField.text)
        return true
    }
}
