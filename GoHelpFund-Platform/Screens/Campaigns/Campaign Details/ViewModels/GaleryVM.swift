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
        let test = ["https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080","https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080", "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080", "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080"]
        return campaign.resourcesUrl.images.map { URL(string: $0) }
    }
    
    var imagesCount: Int {
        return imagesUrls.count
    }
}
