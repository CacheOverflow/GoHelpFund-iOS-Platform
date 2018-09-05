//
//  CreateCampaignStep4.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 8/30/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit

protocol CreateCampaignStep4Delegate {
    func didTapUploadMedia()
    func didTapSkip()
    func didTapShowSelected()
}

class CreateCampaignStep4: NibView {
    var delegate: CreateCampaignStep4Delegate?
    var imageCount: Int = 0
    
    @IBOutlet var bottomLabel: UILabel!
    
    
    init(delegate: CreateCampaignStep4Delegate) {
        super.init(frame: .zero)
        
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateItems(count: Int) {
        imageCount = count
        if count > 0 {
            if count == 1 {
                bottomLabel.text = "VIEW \(count) SELECTED ITEM"
            } else {
                bottomLabel.text = "VIEW \(count) SELECTED ITEMS"
            }
        } else {
            bottomLabel.text = "SKIP"
        }
    }
    
    @IBAction func tapUploadMedia(_ sender: Any) {
        delegate?.didTapUploadMedia()
    }
    
    @IBAction func tapSkip(_ sender: Any) {
        if imageCount > 0 {
            delegate?.didTapShowSelected()
        } else {
            delegate?.didTapSkip()
        }
        
    }
}
