//
//  Campaign.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 6/28/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation
import JSONDecoder_Keypath

enum JSONErrors: Error {
    case nilElement
}

protocol JSONable: Codable {
    associatedtype Element
    func toJsonString() -> String?
    static func fromJSONListData<Element: Codable>(data: Data, keyPath: String?) throws -> [Element]
    static func fromJSONData<Element: Codable>(data: Data, keyPath: String?) throws -> Element
}

extension JSONable {
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    func toJsonString() -> String? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let data = try encoder.encode(self)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    static func fromJSONData<Element: Codable>(data: Data, keyPath: String? = nil) throws -> Element {
        if let path = keyPath {
            let elements = try decoder.decode(Element.self, from: data, keyPath: path)
            return elements
        }
        let elements = try decoder.decode(Element.self, from: data)
        return elements
    }
    
    static func fromJSONListData<Element: Codable>(data: Data, keyPath: String? = nil) throws -> [Element] {
        if let path = keyPath {
            let elements = try decoder.decode([Element].self, from: data, keyPath: path)
            return elements
        }
        let elements = try decoder.decode([Element].self, from: data)
        return elements
    }
}

/*
 {
 "id" : "cd881764-bea1-4249-b86d-f8fb8182eec1",
  "title" : "Transplant needed",
 "description" : "Teenager needs heart surgery",
 "amount_raised" : 0,
 "expenses_description" : "Overall surgery operations",
 "start_date" : "2019-06-29T10:30:00Z",
 "category" : {
 "status" : "CREATED",
 "id" : "0d60a85e-0b90-4482-a14c-108aea2557aa",
 "image_url" : "https:\/\/s3.eu-central-1.amazonaws.com\/gohelpfund-resources\/categories\/charity.png",
 "name" : "Charity",
 "description" : "Help a charity or nonprofit right away"
 },
 "end_date" : "2019-06-29T12:30:00Z",

 "amount_goal" : 50000,

 "location" : "UK, London",
 ],

 */
public struct Campaign: JSONable {
    typealias Element = Campaign
    
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
    let locationDisplayed: String?
    let locationCoordinates: Location?
    
    enum CodingKeys: String, CodingKey {
        case raisedGoal = "amount_goal"
        case raisedTotal = "amount_raised"
        case expensesDescription = "expenses_description"
        case startDate = "start_date"
        case endDate = "end_date"
        
    }
}

struct Location: Codable {
    let latitude: Float
    let longitude: Float
}

struct ResourcesUrl: Codable {
    /*
 {
 "status" : "CREATED",
 "id" : "f618f5a8-380e-44fb-9b4e-b3286f29dcc8",
 "name" : "Image 3",
 "url" : "https:\/\/s3.eu-central-1.amazonaws.com\/gohelpfund-resources\/categories\/charity.png"
 }*/
    let videos: [String]
    let images: [String]
}

struct User: Codable {
    /*
    "fundraiser" : {
    "age" : 28,
    "id" : "bc8250bb-f7eb-4adc-925c-2af315cc4a55",
    "profile_image_url" : "https:\/\/s3.eu-central-1.amazonaws.com\/gohelpfund-resources\/categories\/charity.png",
    "status" : "PENDING",
    "name" : "John"
    },
 */
    let name: String
    let jobTitle: String
    let company: String
    let imageUrl: String?
    let social: Social
    
}

struct Social: Codable {
    let facebook: String?
    let twitter: String?
    let linkedin: String?
    let website: String?
    let other: String?
    
    enum CodingKeys: String, CodingKey {
        case twitter
        case website
        case linkedin
        case facebook
        case other
    }
}

/*
 {
 "status" : "CREATED",
 "id" : "0d60a85e-0b90-4482-a14c-108aea2557aa",
 "image_url" : "https:\/\/s3.eu-central-1.amazonaws.com\/gohelpfund-resources\/categories\/charity.png",
 "name" : "Charity",
 "description" : "Help a charity or nonprofit right away"
 },
 */
public struct Category: JSONable {
    typealias Element = Category
    
    let title: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case imageUrl
    }
}

enum Currency: String, Codable {
    case dolar = "$"
    case euro = "euro"
    case eth = "eth"
    case help = "help"
}
