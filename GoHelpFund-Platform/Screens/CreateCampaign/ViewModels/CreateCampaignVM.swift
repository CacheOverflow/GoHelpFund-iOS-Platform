//
//  CreateCampaignVM.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 8/30/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation

class CreateCampaignVM {
    var title: String? = nil
    var description: String?
    var expensesDescription: String?
    var startDate: Date?
    var endDate: Date?
    var raisedGoal: Double?
    var raisedTotal: Double?
    var backers: Int?
    
    var category: Category?
    var currency: Currency?
    var resourcesUrl: ResourcesUrl?
    var author: User?
    var locationDisplayed: String?
    var locationCoordinates: Location?
    
    func updateForStep1(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    func updateForStep2(amount: String, expensesDescription: String) {
        self.raisedGoal = Double(amount)
        self.expensesDescription = expensesDescription
    }
    
    //func updateForStep3(startDate)
    
}
