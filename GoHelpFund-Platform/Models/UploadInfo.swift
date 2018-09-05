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
    
    let endpointURL, bucketName, accessKeyID, secretAccessKey: String
    let bucketRegion: String
    
    enum CodingKeys: String, CodingKey {
        case endpointURL = "endpointUrl"
        case bucketName
        case accessKeyID = "accessKeyId"
        case secretAccessKey, bucketRegion
    }
}
