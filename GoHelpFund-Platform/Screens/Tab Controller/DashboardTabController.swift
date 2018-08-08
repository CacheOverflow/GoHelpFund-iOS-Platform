//
//  DashboardTabController.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 6/29/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit

class DashboardTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewControllers = viewControllers else { return }
        setupNavigationBars(for: viewControllers)
    }
    
    func setupNavigationBars(for viewControllers: [UIViewController]) {
        for vc in viewControllers {
            if let navVC = vc as? UINavigationController, let vc = navVC.viewControllers.first {
                vc.navigationItem.setRightBarButton(barButton, animated: true)
            }
        }
    }
    
    var barButton: UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "create")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(createCampaign))
    }
    
    @objc func createCampaign() {
        let navigator = CampaignListNavigationFactory(storyboard: UIStoryboard(name: StoryboardIds.createCampaignStoryboardId.rawValue, bundle: nil))
        let nextVC = navigator.createSelectCategory()
        
        UIApplication.shared.keyWindow?.rootViewController = nextVC
    }

}
