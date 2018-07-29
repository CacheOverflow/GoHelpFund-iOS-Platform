//
//  CampaignDescriptionCell.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 7/5/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit

class CampaignDescriptionCell: BaseTableViewCell {

    @IBOutlet var amountRaisedLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setupWithVM(vm: Any) {
        guard let vm = vm as? CampaignDetailsVM else { fatalError("wrong vm")}
        
        amountRaisedLabel.text = vm.raisedTotalDisplayed
        descriptionLabel.text = vm.description
    }
}
