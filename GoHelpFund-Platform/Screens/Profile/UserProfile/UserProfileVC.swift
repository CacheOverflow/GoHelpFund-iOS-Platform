//
//  UserProfileVC.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 11/12/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController {
    weak var delegate: ProfileStateDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logout(_ sender: Any) {
        delegate?.didChangeLoginState(state: .loggedOut)
    }
    
}
