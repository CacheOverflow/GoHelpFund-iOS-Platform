//
//  GaleryVM.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 7/5/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation

struct GaleryVM {
    var campaign: Campaign
    
    init(campaign: Campaign) {
        self.campaign = campaign
    }
    
    var imagesUrls: [URL?] {
        return campaign.mediaResources.map { URL(string: $0.url) }
    }
    
    var imagesCount: Int {
        return imagesUrls.count
    }
}
