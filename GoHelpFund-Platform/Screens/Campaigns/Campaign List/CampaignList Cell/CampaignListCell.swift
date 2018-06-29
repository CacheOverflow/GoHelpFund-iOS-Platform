//
//  CampaignListCell.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 6/29/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit
import SDWebImage

class CampaignListCell: BaseTableViewCell {
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var timeLeftLabel: UILabel!
    @IBOutlet var numberOfBackersLabel: UILabel!
    @IBOutlet var raisedPercentageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupWithCampaign(campaign: Campaign) {
        if let imageString = campaign.resourcesUrl.images.first {
            let url = URL(string: imageString)
            imageView1.sd_setImage(with: url, completed: nil)
        }
        
        titleLabel.text = campaign.title
        authorLabel.text = campaign.author.name
        descriptionLabel.text = campaign.description
        timeLeftLabel.text = campaign.endDate.timeAgoSinceNow()
        numberOfBackersLabel.text = String(campaign.backers)
        
        let percentage = (campaign.raisedTotal / campaign.raisedGoal) * 100
        raisedPercentageLabel.text = String(percentage) + "%"
        
    }
    
}
