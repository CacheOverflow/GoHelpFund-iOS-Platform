//
//  HelpButton.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 7/2/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation
import UIKit

class HelpButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
}
