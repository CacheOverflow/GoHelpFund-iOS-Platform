//
//  CampaignVC.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 7/31/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit
import Eureka

class CreateCampaignVC: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        createForm()
    }
    
    func createForm() {
        form +++ Section("User Data")
            <<< TextRow(){ row in
                row.title = "Full Name"
                row.placeholder = "Please provide your full name"
            }
            <<< TextRow() {
                $0.title = "Job Title"
                $0.placeholder = "Please let us know what yo do"
            }
            <<< TextRow() {
                $0.title = "Company"
                $0.placeholder = "Company"
            }
        
            +++ Section("Campaign Details")
            
            <<< TextRow() {
                $0.title = "Title"
                $0.placeholder = "Campaign Title"
            }
            <<< TextRow() {
                $0.title = "Description"
                $0.placeholder = "Campaign description"
            }
            <<< IntRow() {
                $0.title = "Amount needed"
                $0.placeholder = "Please provide how much do you need to raise"
            }
            
            <<< DateRow() {
                $0.title = "Start Date"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
            }
            <<< DateRow() {
                $0.title = "End Date"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
        }
        
    }
    
    func setupNavigationBar() {
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(tapDone))
        navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    @objc func tapDone() {
        let navigator = CampaignListNavigationFactory()
        let nextVC = navigator.createDashboard()
        
        UIApplication.shared.keyWindow?.rootViewController = nextVC
    }

}
