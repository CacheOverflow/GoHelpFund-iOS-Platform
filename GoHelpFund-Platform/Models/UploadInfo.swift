//
//  UploadInfo.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 9/5/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation

public struct UploadInfo: JSONable {
    typealias Element = UploadInfo
    
    let accessKeySecret, accessKeyID, endpointURL, bucketName: String
    let bucketRegion: String
    
    enum CodingKeys: String, CodingKey {
        case accessKeySecret = "access_key_secret"
        case accessKeyID = "access_key_id"
        case endpointURL = "endpoint_url"
        case bucketName = "bucket_name"
        case bucketRegion = "bucket_region"
    }
}
