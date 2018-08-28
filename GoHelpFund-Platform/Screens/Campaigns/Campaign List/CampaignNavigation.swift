//
//  CampaignListNavigation.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 7/20/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation
import UIKit

enum StoryboardIds: String {
    case mainStoryboardId = "Dashboard"
    case createCampaignStoryboardId = "CreateCampaign"
}

let campaignDetailsId = "CampaignDetailsVC"

class CampaignListNavigationFactory {
    var storyboard: UIStoryboard
    
    init(storyboard: UIStoryboard = UIStoryboard(name: StoryboardIds.mainStoryboardId.rawValue, bundle: nil)) {
        self.storyboard = storyboard
    }
}

extension CampaignListNavigationFactory: CampaignListNavigation {
    
    func createCampaignDetails(campaign: Campaign) -> CampaignDetailsVC {
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: CampaignDetailsVC.self)) as? CampaignDetailsVC else { fatalError() }
        vc.campaign = campaign
        return vc
    }
    
    func createDashboard() -> UIViewController? {
        return storyboard.instantiateInitialViewController()
    }
    
    func createSelectCategory() -> UIViewController? {
        return storyboard.instantiateInitialViewController()
    }
    
    func createCreateCampaign() -> UIViewController {
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: CreateCampaignVC.self)) as? CreateCampaignVC else { fatalError() }
        return vc
    }
    
    func createMediaPicker() -> UIViewController {
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: MediaPickerVC.self)) as? MediaPickerVC else { fatalError() }
        return vc
    }
}
