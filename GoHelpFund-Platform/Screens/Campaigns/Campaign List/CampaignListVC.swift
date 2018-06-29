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

        getCampaigns()
    }

    func getCampaigns() {
        let campaignService = CampaignService()
        campaignService.getCampaignList(success: { (campaignsList) in
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
        
        cell.setupWithCampaign(campaign: campaign)
        return cell
    }
}
