//
//  CampaignDetailedCell.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 7/5/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit
import LinearProgressBar

class CampaignDetailedCell: BaseTableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var endDateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var progressBar: LinearProgressBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupWithVM(vm: CampaignDetailsVM) {
        titleLabel.text = vm.title
        startDateLabel.text = vm.startDate
        endDateLabel.text = vm.endDate
        locationLabel.text = vm.locationDisplayed
        progressLabel.text = vm.raisedPercentageDisplayed
        
        //in order to use cgfloat, I have to import UIKit and i don't want to import it in the vm
        progressBar.progressValue = CGFloat(vm.raisedPercentageProgress)
    }
    
}
