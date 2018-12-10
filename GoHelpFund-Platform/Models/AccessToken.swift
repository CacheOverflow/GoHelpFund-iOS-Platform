//
//  AccessToken.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 11/9/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation

struct AccessToken: JSONable {
    typealias Element = AccessToken
    
    var value = ""
    
    enum CodingKeys: String, CodingKey {
        case value = "access_token"
    }
    
}
