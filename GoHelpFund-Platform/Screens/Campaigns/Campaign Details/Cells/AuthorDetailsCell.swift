//
//  AuthorDetailsCell.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 7/5/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit
import SDWebImage

protocol AuthorDetailsDelegate {
    func didTapSocial(withLink link: URL)
}

class AuthorDetailsCell: BaseTableViewCell {
    var delegate: AuthorDetailsDelegate?
    var vm: AuthorDetailsVM!
    
    @IBOutlet var authorImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var jobLabel: UILabel!

    @IBOutlet var websiteView: UIView!
    @IBOutlet var twitterView: UIView!
    @IBOutlet var facebookView: UIView!
    @IBOutlet var linkedinView: UIView!
    @IBOutlet var otherView: UIView!

    @IBOutlet var titleExpensesLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }

    func setup() {
        descriptionLabel.sizeToFit()
    }
    
    override func setupWithVM(vm: Any) {
        guard let vm = vm as? AuthorDetailsVM else { fatalError("wrong vm") }
        self.vm = vm
        setupSocialViews()
        authorImageView.sd_setImage(with: vm.authorImageUrl, placeholderImage: UIImage(named: "user_placeholder"), options: SDWebImageOptions.retryFailed, completed: nil)
        nameLabel.text = vm.name
        companyLabel.text = vm.company
        jobLabel.text = vm.jobTitle
        descriptionLabel.text = vm.description
    }
    
    func setupSocialViews() {
        websiteView.isHidden = vm.shouldHideSocialView(for: vm.websiteUrl)
        facebookView.isHidden = vm.shouldHideSocialView(for: vm.facebookUrl)
        twitterView.isHidden = vm.shouldHideSocialView(for: vm.twitterUrl)
        linkedinView.isHidden = vm.shouldHideSocialView(for: vm.linkedinUrl)
        otherView.isHidden = vm.shouldHideSocialView(for: vm.otherUrl)
    }
    
    // MARK: - IBActions
    
    @IBAction func tapLinkedin(_ sender: UIButton) {
        didTapSocial(withLink: vm.linkedinUrl)
    }
    
    @IBAction func tapTwitter(_ sender: Any) {
        didTapSocial(withLink: vm.twitterUrl)
    }
    
    @IBAction func tapFacebook(_ sender: Any) {
        didTapSocial(withLink: vm.facebookUrl)
    }
    
    @IBAction func tapOther(_ sender: Any) {
        didTapSocial(withLink: vm.otherUrl)
    }
    
    @IBAction func tapWebsite(_ sender: Any) {
        didTapSocial(withLink: vm.websiteUrl)
    }
    
    func didTapSocial(withLink url: URL?) {
        guard let url = url else { return }
        delegate?.didTapSocial(withLink: url)
    }
}
