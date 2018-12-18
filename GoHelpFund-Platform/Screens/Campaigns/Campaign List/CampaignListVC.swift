//
//  CampaignListVC.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 6/29/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit

class CampaignListVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    var campaigns = [Campaign]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()

        let authService = AuthService()
        authService.authorizate(success: {
            self.getCampaigns()
            self.setupTableView()
        }) {
            self.setupNoData()
        }
    }
    
    func setupNavigationBar() {
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo320")
        imageView.image = image
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
    }
    
    func setupNoData() {
        
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 185
        CampaignListCell.registerNibToTableView(tableView: tableView)
    }
    
    func getCampaigns() {
        let campaignService = CampaignService()
        campaignService.getCampaigns(success: { (campaignsList) in
            self.campaigns = campaignsList
            self.tableView.reloadData()
            
        }) {
            //fail
        }
    }

}

extension CampaignListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campaigns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CampaignListCell.cellReuseIdentifier(), for: indexPath) as! CampaignListCell
        let campaign = campaigns[indexPath.row]
        
        cell.setupWithVM(vm: CampaignDetailsVM(campaign: campaign))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let campaign = campaigns[indexPath.row]
        let navigator = CampaignListNavigationFactory()
        let nextVC = navigator.createCampaignDetails(campaign: campaign)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

protocol CampaignListNavigation {
    func createCampaignDetails(campaign: Campaign) -> CampaignDetailsVC
}
