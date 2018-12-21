//
//  ProfileTabContainerVC.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 11/12/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit

class ProfileTabContainerVC: UIViewController {
    private lazy var stateViewController = ProfileContentStateVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        add(stateViewController)
        
        showOnboarding()
        
    }

    func showOnboarding() {
        stateViewController.transition(to: .loggedOut)
    }
    
    func showProfile() {
        stateViewController.transition(to: .loggedIn)
    }

}
