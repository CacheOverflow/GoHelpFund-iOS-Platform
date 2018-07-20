//
//  CampaignDetailsVM.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 7/5/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation

struct CampaignDetailsVM {
    private var dateFormatter: ISO8601DateFormatter = ISO8601DateFormatter()
    
    var campaign: Campaign
    
    init(campaign: Campaign) {
        self.campaign = campaign
    }
    
    var title: String {
        return campaign.title
    }
    
    var startDate: String {
        return dateFormatter.string(from: campaign.startDate)
    }
    
    var endDate: String {
        return dateFormatter.string(from: campaign.endDate)
    }
    
    var locationDisplayed: String {
        return campaign.locationDisplayed ?? ""
    }
    
    var raisedPercentageDisplayed: String {
        return String(raisedPercentageProgress) + "%" + " Raised"
    }
    
    var raisedPercentageProgress : Double {
        return (campaign.raisedTotal / campaign.raisedGoal) * 100
    }
}
