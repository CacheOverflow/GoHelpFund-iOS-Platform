//
//  Campaign.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 6/28/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation

enum JSONErrors: Error {
    case nilElement
}

protocol JSONable: Codable {
    associatedtype Element
    func toJsonString() -> String?
    static func fromJSONListData<Element: Codable>(data: Data) throws -> [Element]
    static func fromJSONData<Element: Codable>(data: Data) throws -> Element
}

extension JSONable {
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    func toJsonString() -> String? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    static func fromJSONData<Element: Codable>(data: Data) throws -> Element {
        let elements = try decoder.decode(Element.self, from: data)
        return elements
    }
    
    static func fromJSONListData<Element: Codable>(data: Data) throws -> [Element] {
        let elements = try decoder.decode([Element].self, from: data)
        return elements
    }
}

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
}

struct Location: Codable {
    let latitude: Float
    let longitude: Float
}

struct ResourcesUrl: Codable {
    let videos: [String]
    let images: [String]
}

struct User: Codable {
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

public struct Category: JSONable {
    typealias Element = Category
    
    let title: String
    let imageUrl: String
}

enum Currency: String, Codable {
    case dolar = "$"
    case euro = "euro"
    case eth = "eth"
    case help = "help"
}
