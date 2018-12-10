//
//  AuthService.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 11/9/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation

public struct AuthService {
    
    func authorizate(success: @escaping () -> (), failure: @escaping () -> ()) {
        apiProvider.request(API.authorizate()) { (result) in
            switch result {
            case let .success(response):
                print(response)
                do {
                    let token : AccessToken = try AccessToken.fromJSONData(data: response.data)
                    UserDefaults.standard.set(token.value, forKey: "token")
                    success()
                } catch let error {
                    failure()
                }
                
            case .failure(let error):
                failure()
            }
        }
    }
    
    func signUp(email: String, password: String, fullName: String, success: @escaping () -> (), failure: @escaping () -> ()) {
        apiProvider.request(API.signUp(username: email, password: password, fullName: fullName), completion: { (result) in
            
            
        })
    }
    
    func login(email: String, password: String, success: @escaping () -> (), failure: @escaping () -> ()) {
        apiProvider.request(API.login(username: email, password: password), completion: { (result) in
            
            
        })
    }
}
