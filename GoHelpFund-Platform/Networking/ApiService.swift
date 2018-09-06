//
//  ApiService.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 6/27/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation
import Moya

// MARK: - Provider setup

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

let apiProvider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

// MARK: - Provider support

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum API {
    case getCampaigns()
    case getCategories()
    case getMediaUploadInfo()
    case createCampaign(Campaign)
}

extension API: TargetType {
    //api.gohelpfund.com:5555/v1/categories
    //http://demo0574725.mockable.io/
    public var baseURL: URL { return URL(string: "http://api.gohelpfund.com:5555/v1/")! }
    
    public var path: String {
        switch self {
        case .getCampaigns, .createCampaign(_):
            return "campaigns"
        case .getCategories():
            return "categories"
        case .getMediaUploadInfo():
            return "upload"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .getCategories,
             .getCampaigns,
             .getMediaUploadInfo:
            return .get
        case .createCampaign(_):
            return .post
        default:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .getCampaigns,
             .getCategories,
             .getMediaUploadInfo:
            return .requestPlain
        case .createCampaign(let campaign):
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            return .requestCustomJSONEncodable(campaign, encoder: encoder)
            
        default:
            return .requestPlain
        }
    }
    
    public var validate: Bool {
        return true
    }
    
    public var sampleData: Data {
        return "mock".data(using: String.Encoding.utf8)!
    }
    
    public var headers: [String: String]? {
        return ["Accept": "application/json", "Accept-Language": "", "Content-Type": "application/json"]
    }
    
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

// MARK: - Response Handlers

extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}

