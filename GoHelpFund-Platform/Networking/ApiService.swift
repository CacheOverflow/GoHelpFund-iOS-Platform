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
    case signUp(username: String, password: String)
    case login(username: String, password: String)
    case authorizate()
    case getCampaigns()
    case getCategories()
    case getMediaUploadInfo()
    case createCampaign(Campaign)
}

extension API: TargetType {
    public var baseURL: URL { return URL(string: API_CONSTANTS.BASE_URL)! }
    
    public var path: String {
        switch self {
        case .authorizate():
            return "auth/oauth/token"
        case .signUp(_, _):
            return "auth/signup"
        case .login(_, _):
            return ""
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
        case .authorizate():
            return .requestParameters(parameters: ["grant_type" : "client_credentials",
                                                   "scope" : "mobile-client"], encoding: JSONEncoding.default)
        case .signUp(let username, let password):
            return .requestParameters(parameters: ["username" : username,
                                                   "password" : password,
                                                   "scope" : "mobile-client"], encoding: JSONEncoding.default)
        case .login(let username, let password):
            return .requestParameters(parameters: ["grant_type": "password",
                                                   "username" : username,
                "password" : password,
                "scope" : "mobile-client"], encoding: JSONEncoding.default)
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
        return ["Accept": "application/json", "Accept-Language": "", "Content-Type": "application/json", "Authorization": token]
    }
    
    var token: String {
        switch self {
        case .authorizate(), .login(_, _), .signUp(_, _):
            return "Basic " + API_CONSTANTS.CLIENT_CREDENTIALS
        default:
            let token = UserDefaults.standard.string(forKey: "token") ?? ""
            return "Bearer " + token
        }
    }
    
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

