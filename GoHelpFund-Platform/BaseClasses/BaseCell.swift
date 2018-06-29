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
    
    static func registerNibToTableView(tableView: UITableView){
        let nib: UINib = UINib(nibName: String(describing: self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: String(describing: self))
    }
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
    
}
