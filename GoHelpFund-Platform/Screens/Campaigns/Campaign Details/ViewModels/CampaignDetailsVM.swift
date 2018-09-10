//
//  CampaignDetailsVM.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 7/5/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation

struct CampaignDetailsVM {
    private var dateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        
        return formatter
    }
    
    var campaign: Campaign
    
    init(campaign: Campaign) {
        self.campaign = campaign
    }
    
    var title: String {
        return campaign.title
    }
    
    var startDate: String {
        return "Start: " + dateFormatter.string(from: campaign.startDate)
    }
    
    var endDate: String {
        return "End: " + dateFormatter.string(from: campaign.endDate)
    }

    var locationDisplayed: String {
        return "Location: " + (campaign.locationDisplayed ?? "Unknown Location")
    }
    
    var raisedPercentageDisplayed: String {
        return String(raisedPercentageProgress) + "%" + " Raised"
    }
    
    var raisedPercentageProgress : Double {
        return (campaign.raisedTotal / campaign.raisedGoal) * 100
    }
    
    var raisedTotalDisplayed: String {
        return "$" + String(campaign.raisedTotal) + " Raised"
    }
    
    var description: String {
        return campaign.description
    }
    
    var authorName: String? {
        return campaign.author?.name
    }
    
    var firstImageUrl: URL? {
        guard let imageString = campaign.mediaResources.first?.url else { return nil }
        return URL(string: imageString)
    }
    
    var categoryImageUrl: URL? {
        return URL(string: campaign.category.imageURL)
    }
    
    var categoryTitleDisplayed: String? {
        return "Category: " + campaign.category.name
    }
    
    var remainingTime: String? {
        let currentDate = Date()
        guard let remainingDays = Calendar.current.dateComponents([.day], from: currentDate, to: campaign.endDate).day else { return nil }
        return String(remainingDays) + " days left"
    }
    
    var displayedBackersCount: String {
        return String(campaign.backers)
    }
}
