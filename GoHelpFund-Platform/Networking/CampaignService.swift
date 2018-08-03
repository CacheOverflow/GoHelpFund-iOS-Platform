//
//  CampaignProvider.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 6/27/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation

public struct CampaignService {
    
    public func getCampaignList(success: @escaping ([Campaign]) -> (), failure: @escaping () -> ()) {
        apiProvider.request(API.getCampaigns()) { (result) in
            switch result {
            case let .success(response):
                do {
                    let campaigns : [Campaign] = try Campaign.fromJSONListData(data: response.data)
                    success(campaigns)
                } catch let error {
                    print(error)
                }
                
            case .failure(let error):
                print(error)
                failure()
            }
        }
    }
}

