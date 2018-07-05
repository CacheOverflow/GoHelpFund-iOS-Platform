//
//  GalleryCell.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 7/2/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit

class GalleryCell: BaseTableViewCell {

    @IBOutlet var scrollView: UIScrollView!
    var images = [UIImage]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        images = [#imageLiteral(resourceName: "animals"), #imageLiteral(resourceName: "education"), #imageLiteral(resourceName: "charity")]
        setupScrollView()
    }

    func setupScrollView() {
        for i in 0..<images.count {
            let imageView = UIImageView()
            let x = contentView.frame.size.width * CGFloat(i)
            imageView.frame = CGRect(x: x, y: 0, width: contentView.frame.width, height: contentView.frame.height)
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = UIColor.red
            imageView.image = images[i]
            
            scrollView.contentSize.width = scrollView.frame.size.width * CGFloat(i + 1)
            scrollView.addSubview(imageView)
        }
    }
    
    
}
