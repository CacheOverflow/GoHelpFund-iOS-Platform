//
//  AuthorDetailsVM.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 7/5/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation

struct AuthorDetailsVM {
    var campaign: Campaign
    
    init(campaign: Campaign) {
        self.campaign = campaign
    }
    //i could send just an uiimage but the user may also upload a gif
    var authorImageUrl: URL? {
        guard let imageUrl = campaign.author?.profileImageURL else { return nil }
        return URL(string: imageUrl)
    }
    
    var name: String? {
        return campaign.author?.name
    }
    
    var company: String? {
        return campaign.author?.professional.companyName
    }
    
    var jobTitle: String? {
        return campaign.author?.professional.jobTitle
    }
    
    var websiteUrl: URL? {
        guard let website = campaign.author?.social.website else { return nil }
        return URL(string: website)
    }
    
    var facebookUrl: URL? {
        guard let facebook = campaign.author?.social.facebook else { return nil }
        return URL(string: facebook)
    }
    
    var twitterUrl: URL? {
        guard let twitter = campaign.author?.social.twitter else { return nil }
        return URL(string: twitter)
    }
    
    var linkedinUrl: URL? {
        guard let linkedin = campaign.author?.social.linkedin else { return nil }
        return URL(string: linkedin)
    }
    
    var otherUrl: URL? {
        guard let otherUrl = campaign.author?.social.other else { return nil }
        return URL(string: otherUrl)
    }
    
    var description: String {
        return campaign.expensesDescription
    }
    
    func shouldHideSocialView(for url: URL?) -> Bool {
        return url == nil
    }
}
