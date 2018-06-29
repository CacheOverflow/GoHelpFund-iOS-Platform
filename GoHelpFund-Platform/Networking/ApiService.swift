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
    case getCampaignList()
    case getCampaignDetails(String)
}

extension API: TargetType {
    public var baseURL: URL { return URL(string: "http://www.mocky.io/v2/")! }
    public var path: String {
        switch self {
        case .getCampaignList:
            return "5b3637bc3400002d0df88918"
        case .getCampaignDetails(_):
            return "5b34e3b22f00001a04376103"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .getCampaignDetails(_),
             .getCampaignList():
            return .get
        default:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .getCampaignList:
            return .requestPlain
        case .getCampaignDetails(let idCampaign):
            return .requestParameters(parameters: ["id": idCampaign], encoding: URLEncoding.default)
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
        return nil
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

