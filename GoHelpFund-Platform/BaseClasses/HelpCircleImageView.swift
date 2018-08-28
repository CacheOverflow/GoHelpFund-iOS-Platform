//
//  HelpCircleImageView.swift
//  GoHelpFund
//
//  Created by Vlad Batrinu on 1/13/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit

class HelpCircleImageView: UIImageView {
    
        override func layoutSubviews() {
            super.layoutSubviews()
            self.layer.cornerRadius = self.bounds.size.height / 2;
            self.clipsToBounds = true
            self.layer.masksToBounds = true
    }
}
