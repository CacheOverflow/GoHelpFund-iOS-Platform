//
//  OnboardingVC.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 11/12/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit

class OnboardingVC: UIViewController {
    //vm for extracting data
    var vm = OnboardingVM()

    //views
    @IBOutlet var containerView: UIView!
    var loadedViews = [NibView]()
    
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var previousButton: UIButton!
    @IBOutlet var finishButton: HelpButton!
    
    //steps
    @objc dynamic var step: Int = 0
    var stepObserver: NSKeyValueObservation!
    var nrSteps: Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupSteps() {
        finishButton.isHidden = true
        previousButton.isEnabled = false
    }
    
    func setupKVO() {
        stepObserver = observe(\.step, options: [.new, .old], changeHandler: { (_, change) in
            guard let nextStep = change.newValue else { return }
            nextStep == self.nrSteps - 1 ? (self.nextButton.isEnabled = false) : (self.nextButton.isEnabled = true)
            nextStep == 0                ? (self.previousButton.isEnabled = false) : (self.previousButton.isEnabled = true)
        })
    }
    
    func login() {
        
    }


}
