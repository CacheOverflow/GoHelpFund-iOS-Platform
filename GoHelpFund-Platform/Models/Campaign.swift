//
//  Campaign.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 6/28/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation

public struct Campaign: Codable {
    let id: String
    let title: String
    let description: String
    let expensesDescription: String
    let startDate: Date
    let endDate: Date
    let raisedGoal: Double
    let raisedTotal: Double
    let backers: Int
    
    let category: Category
    let currency: Currency
    let resourcesUrl: ResourcesUrl
    let author: User
}

struct ResourcesUrl: Codable {
    let videos: [String]
    let images: [String]
}

struct User: Codable {
    let name: String
    let jobTitle: String
    let company: String
    let social: Social
    
}

struct Social: Codable {
    let facebook: String
    let twitter: String
    let linkedin: String
}

enum Currency: String, Codable {
    case dolar = "dolar"
    case euro = "euro"
    case eth = "eth"
    case help = "help"
}

enum Category: String, Codable {
    case medical
    case volunteer
    case emergencies
    case education
    case memorials
    case sports
    case animals
    case wishes
    case competitions
    case charity
    case newlyweds
    case faith
    case travel
    case creative
    case community
    case events
    case business
    case family
}
