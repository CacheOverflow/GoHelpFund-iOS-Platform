//
//  CampaignProvider.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 6/27/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation

public struct CampaignService {
    
    func createCampaign(campaign: Campaign, success: @escaping (Campaign) -> (), failure: @escaping () -> ()) {
        apiProvider.request(API.createCampaign(campaign)) { (result) in
            switch result {
            case let .success(response):
                do {
                    let campaign : Campaign = try Campaign.fromJSONData(data: response.data)
                    success(campaign)
                } catch let error {
                    failure()
                }
                
            case .failure(let error):
                failure()
            }
        }
    }
    
    func getCampaigns(success: @escaping ([Campaign]) -> (), failure: @escaping () -> ()) {
        apiProvider.request(API.getCampaigns()) { (result) in
            switch result {
            case let .success(response):
                do {
                    let campaigns : [Campaign] = try Campaign.fromJSONListData(data: response.data, keyPath: "content")
                    success(campaigns)
                } catch let error {
                    failure()
                    
                }
            case .failure(let error):
                failure()
            }
        }
    }
    
    func getCategories(success: @escaping ([Category]) -> (), failure: @escaping () -> ()) {
        apiProvider.request(API.getCategories()) { (result) in
            switch result {
            case let .success(response):
                do {
                    let categories : [Category] = try Category.fromJSONListData(data: response.data, keyPath: "content")
                    success(categories)
                } catch let error {
                    failure()
                }
                
            case .failure(let error):

                failure()
            }
        }
    }
    
    func getMediaUploadData(success: @escaping (UploadInfo) -> (), failure: @escaping () -> ()) {
        apiProvider.request(API.getMediaUploadInfo()) { (result) in
            switch result {
            case let .success(response):
                do {
                    let uploadInfo : UploadInfo = try UploadInfo.fromJSONData(data: response.data)
                    success(uploadInfo)
                } catch let error {
                    failure()
                }
                
            case .failure(let error):
                
                failure()
            }
        }
    }
}

