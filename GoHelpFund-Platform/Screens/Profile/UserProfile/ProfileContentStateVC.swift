//
//  ProfileContentStateVC.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 11/12/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit

class ProfileContentStateVC: UIViewController {

    private var state: LoginState?
    private var shownViewController: UIViewController?
    
    func transition (to newState: LoginState) {
        shownViewController?.remove()
        let vc = viewController(for: newState)
        add(vc)
        shownViewController = vc
        state = newState
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let state = state {
            transition(to: state)
        }
    }
    
    private lazy var onboardingVC: OnboardingVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Dashboard", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "OnboardingVC") as! OnboardingVC
        
        return viewController
    }()
    
    private lazy var userProfileVC: UserProfileVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Dashboard", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        
        return viewController
    }()
}

private extension ProfileContentStateVC {
    func viewController(for state: LoginState) -> UIViewController {
        switch state {
        case .loggedIn:
            return userProfileVC
        case .loggedOut:
            return onboardingVC
        }
    }
}

extension ProfileContentStateVC {
    enum LoginState {
        case loggedIn
        case loggedOut
    }
}


