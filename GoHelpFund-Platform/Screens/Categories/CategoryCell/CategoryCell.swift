//
//  CategoryCell.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 8/3/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit
import SDWebImage

class CategoryCell: BaseCollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    func setupWithVM(vm: CategoryCellVM) {
        customizeLayout()
        imageView.sd_setImage(with: vm.imageUrl, placeholderImage: UIImage(named: "charity"), options: .retryFailed, completed: nil)
        titleLabel.text = vm.title
    }
    
    func customizeLayout() {
        contentView.layer.cornerRadius = 2
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
