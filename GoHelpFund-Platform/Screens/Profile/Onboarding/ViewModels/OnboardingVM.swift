//
//  OnboardingVM.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 11/13/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation

class OnboardingVM {
    var email: String?
    var password: String?
    var fullName: String?
    
    func updateWithEmail(email: String?) {
        self.email = email
    }
    
    func updateWithPassword(password: String?) {
        self.password = password
    }
    
    func updateWithFullName(fullName: String?) {
        self.fullName = fullName
    }
}
