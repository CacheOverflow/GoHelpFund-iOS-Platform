//
//  AwsService.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 10/3/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation
import AWSS3

struct AwsUploadService {
    let credentialsProvider = AWSStaticCredentialsProvider(accessKey: AWS_CONSTANTS.ID, secretKey: AWS_CONSTANTS.KEY)
    
    func uploadImage(image: UIImage, success: @escaping (MediaResource) -> (), failure: @escaping () -> ()) {
        guard let uploadRequest = uploadRequest(uiImage: image) else {
            failure()
            return
        }
        setupConfiguration()
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            guard let _ = task.result, let url = AWSS3.default().configuration.endpoint.url, let bucket = uploadRequest.bucket, let key = uploadRequest.key else {
                failure()
                return nil
            }
            let publicUrl = url.appendingPathComponent(bucket).appendingPathComponent(key)
            let mediaResource = MediaResource(name: key, url: publicUrl.absoluteString, type: "image", format: "jpeg")
            success(mediaResource)
            
            return nil
        })
    }
    
    func setupConfiguration() {
        let configuration = AWSServiceConfiguration(region: .EUCentral1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    func uploadRequest(uiImage: UIImage) -> AWSS3TransferManagerUploadRequest? {
        guard let uploadRequest = AWSS3TransferManagerUploadRequest(), let imageFileUrl = imageFileUrl(uiImage: uiImage) else { return nil }
        uploadRequest.bucket = AWS_CONSTANTS.BUCKET_NAME
        uploadRequest.key = "\(UUID().uuidString).jpeg"
        uploadRequest.contentType = "image/jpeg"
        uploadRequest.body = imageFileUrl
        uploadRequest.acl = .publicRead
        
        return uploadRequest
    }
    
    func imageFileUrl(uiImage: UIImage) -> URL? {
        let uuid = UUID().uuidString
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("\(uuid).jpeg") else { return nil }
        let imageData = UIImageJPEGRepresentation(uiImage, 0)
        FileManager.default.createFile(atPath: path, contents: imageData, attributes: nil)
        
        return URL(fileURLWithPath: path)
    }
}
