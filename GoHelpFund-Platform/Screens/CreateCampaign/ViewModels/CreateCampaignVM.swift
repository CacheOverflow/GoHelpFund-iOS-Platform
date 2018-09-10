//
//  CreateCampaignVM.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 8/30/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation

class CreateCampaignVM {
    var title: String!
    var description: String!
    var expensesDescription: String!
    var startDate: Date!
    var endDate: Date!
    var raisedGoal: Double!
    
    var category: Category!
    var resourcesUrl = [MediaResource]()
    var locationDisplayed: String!
    
    func updateForStep1(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    func updateForStep2(amount: String, expensesDescription: String) {
        self.raisedGoal = Double(amount)
        self.expensesDescription = expensesDescription
    }
    
    func updateForStep3(startDate: Date, endDate: Date, location: String) {
        self.startDate = startDate
        self.endDate = endDate
        self.locationDisplayed = location
    }
    
    func updateForStep4(name: String, url: URL, type: String, format: String) {
        let mediaResource = MediaResource(name: name, url: url.absoluteString, type: type, format: format)
        resourcesUrl.append(mediaResource)
    }
    
}
