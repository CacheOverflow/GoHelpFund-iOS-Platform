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
        
        setupProgressBarLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //titleLabel.sizeToFit()
    }
    
    func setupProgressBarLayout() {
        progressBar.barColorForValue = colorForProgress
        
        progressBar.barColor = .green
        progressBar.trackColor = .lightGray
        progressBar.barThickness = 25
        progressBar.barPadding = -12
        progressBar.trackPadding = 0
    }

    func colorForProgress(value: Float) -> UIColor {
        switch value {
        case ..<20:
            return .red
        case 20..<60:
            return .yellow
        case 60...100:
            return .green
        default:
            return .green
        }
    }
    
    override func setupWithVM(vm: Any) {
        guard let vm = vm as? CampaignDetailsVM else { fatalError("wrong vm")}
        
        titleLabel.text = vm.title
        startDateLabel.text = vm.startDate
        endDateLabel.text = vm.endDate
        locationLabel.text = vm.locationDisplayed
        progressLabel.text = vm.raisedPercentageDisplayed

        //in order to use cgfloat, I have to import UIKit and i don't want to import it in the vm
        progressBar.progressValue = CGFloat(vm.raisedPercentageProgress)

        progressLabel.textColor = colorForProgress(value: Float(vm.raisedPercentageProgress))
    }

}
