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
    @IBOutlet var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupScrollView()
        setupPageControl()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func setupScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    func setupPageControl() {
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.blue
        
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: .valueChanged)
    }
    
    override func setupWithVM(vm: Any) {
        guard let vm = vm as? GaleryVM else { fatalError("wrong vm") }
        
        updateLayout(for: vm.imagesCount)
        setup(with: vm)
    }
    
    func updateLayout(for elementsCount: Int) {
        scrollView.contentSize = CGSize(width: contentView.frame.size.width * CGFloat(elementsCount), height: scrollView.frame.size.height)
        pageControl.numberOfPages = elementsCount
    }
    
    func setup(with vm: GaleryVM) {
        vm.imagesUrls.enumerated().forEach { (offset, imageUrl) in
            self.displayImage(imageUrl: imageUrl, for: offset)
        }
    }

    func displayImage(imageUrl: URL?, `for` offset: Int) {
        let imageView = self.imageView(for: offset)
        imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder.png"))
        
        scrollView.addSubview(imageView)
    }
    
    func imageView(`for` offset: Int) -> UIImageView {
        let xOrigin = self.contentView.frame.size.width * CGFloat(offset)
        let imageView = UIImageView(frame: CGRect(x: xOrigin, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height))
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }
    
    @objc func changePage(sender: AnyObject) {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y :0), animated: true)
    }
}

extension GalleryCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}

