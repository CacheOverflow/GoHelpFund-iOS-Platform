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

public struct Campaign: JSONable {
    typealias Element = Campaign
    
    var id: String? = nil
    var title: String = ""
    var description: String = ""
    var expensesDescription: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date()
    var raisedGoal: Double = 0
    var raisedTotal: Double = 0
    var backers: Int = 0
    
    var category: Category = Category()
    var mediaResources: [MediaResource] = [MediaResource]()
    var author: User? = nil
    var locationDisplayed: String? = nil
    var locationCoordinates: Location? = nil
    
    enum CodingKeys: String, CodingKey {
        case raisedGoal = "amount_goal"
        case raisedTotal = "amount_raised"
        case expensesDescription = "expenses_description"
        case startDate = "start_date"
        case endDate = "end_date"
        case locationDisplayed = "location"
        case mediaResources = "media_resources"
        case author = "fundraiser"
        case id, title, description, backers, category, locationCoordinates
    }
    
    init(vm: CreateCampaignVM) {
        self.title = vm.title
        self.description = vm.description
        self.raisedGoal = vm.raisedGoal
        self.expensesDescription = vm.expensesDescription
        self.startDate = vm.startDate
        self.endDate = vm.endDate
        self.category = vm.category
        self.mediaResources = vm.resourcesUrl
    }
}

struct Location: Codable {
    var latitude: Float
    var longitude: Float
}

struct MediaResource: Codable {
    var id: String? = nil
    var status: String? = nil
    var name, url, type, format: String
    
    init(name: String, url: String, type: String, format: String) {
        self.name = name
        self.url = url
        self.type = type
        self.format = format
    }
}

struct User: Codable {
    var id = ""
    var name: String = ""
    var age: Int = 0
    var profileImageURL: String? = nil
    var status = ""
    var jobTitle = ""
    var company = ""

    
    var social: Social = Social()
    
    enum CodingKeys: String, CodingKey {
        case id, name, age
        case profileImageURL = "profile_image_url"
        case status, social, jobTitle, company
    }
}

struct Social: Codable {
    var facebook: String? = nil
    var twitter: String? = nil
    var linkedin: String? = nil
    var website: String? = nil
    var other: String? = nil
    
    
    enum CodingKeys: String, CodingKey {
        case twitter
        case website
        case linkedin
        case facebook
        case other
    }
}

struct Category: JSONable {
    typealias Element = Category
    
    var id = ""
    var imageURL = ""
    var name = ""
    var description = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case name, description
    }
}

enum Currency: String, Codable {
    case dolar = "$"
    case euro = "euro"
    case eth = "eth"
    case help = "help"
}
