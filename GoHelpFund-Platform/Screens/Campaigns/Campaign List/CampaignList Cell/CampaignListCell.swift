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
    var vm: CampaignDetailsVM!
    
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var timeLeftLabel: UILabel!
    @IBOutlet var numberOfBackersLabel: UILabel!
    @IBOutlet var raisedPercentageLabel: UILabel!
    
    override func setupWithVM(vm: Any) {
        guard let vm = vm as? CampaignDetailsVM else { return }
        imageView1.sd_setImage(with: vm.firstImageUrl, completed: nil)
        categoryImageView.sd_setImage(with: vm.categoryImageUrl, completed: nil)
        titleLabel.text = vm.title
        authorLabel.text = vm.authorName
        descriptionLabel.text = vm.description
        timeLeftLabel.text = vm.remainingTime
        numberOfBackersLabel.text = vm.displayedBackersCount
        raisedPercentageLabel.text = vm.raisedPercentageDisplayed
    }
}
