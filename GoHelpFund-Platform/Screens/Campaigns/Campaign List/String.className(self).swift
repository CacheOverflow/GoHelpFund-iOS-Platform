//
//  CampaignListNavigation.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 7/20/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation
import UIKit

let mainStoryboardId = "Dashboard"

let campaignDetailsId = "CampaignDetailsVC"

class CampaignListNavigationFactory {
    var storyboard: UIStoryboard
    
    init(storyboard: UIStoryboard = UIStoryboard(name: mainStoryboardId, bundle: nil)) {
        self.storyboard = storyboard
    }
}

extension CampaignListNavigationFactory: CampaignListNavigation {
    
    func createCampaignDetails(campaign: Campaign) -> CampaignDetailsVC {
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: CampaignDetailsVC.self)) as? CampaignDetailsVC else { fatalError() }
        vc.campaign = campaign
        return vc
    }
}
