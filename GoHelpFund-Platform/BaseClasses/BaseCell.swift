//
//  BaseCell.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 6/29/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation
import UIKit

class BaseTableViewCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selectionStyle = .none
    }
    
    static func registerNibToTableView(tableView: UITableView) {
        let nib: UINib = UINib(nibName: String(describing: self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: String(describing: self))
    }
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    func setupWithVM(vm: Any) {}
}

class BaseCollectionViewCell: UICollectionViewCell {
    static func registerNibToCollectionView(collectionView: UICollectionView) {
        let nib: UINib = UINib(nibName: String(describing: self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: String(describing: self))
    }
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
    }
}
