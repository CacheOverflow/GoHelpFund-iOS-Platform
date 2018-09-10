//
//  StringExtensions.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 8/29/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    var containsNonWhitespace: Bool {
        return !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
