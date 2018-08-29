//
//  NibView.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 8/8/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation
import UIKit

class NibView: UIView, StepValidator {
    //var isValidStep: Bool
    
    var isValidStep: Bool { return false }
    
    var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    
}

protocol StepValidator {
    var isValidStep: Bool { get }
}

//extension StepValidator {
//    var isValidStep: Bool {
//       return false
//    }
//}

private extension NibView {
    func xibSetup() {
        backgroundColor = UIColor.clear
        view = loadNib()
        view.frame = bounds

        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
    }
}

extension UIView {
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
