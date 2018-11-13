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
    var nrSteps: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSteps()
        setupKVO()
        setupLoadedViews()
        present(loadedView: loadedViews.first, viewToRemove: nil)
    }
    
    func setupSteps() {
        previousButton.isEnabled = false
    }
    
    func setupKVO() {
        stepObserver = observe(\.step, options: [.new, .old], changeHandler: { (_, change) in
            guard let nextStep = change.newValue else { return }
            nextStep == self.nrSteps - 1 ? (self.nextButton.isEnabled = false) : (self.nextButton.isEnabled = true)
            nextStep == 0                ? (self.previousButton.isEnabled = false) : (self.previousButton.isEnabled = true)
        })
    }
    
    func setupLoadedViews() {
        let stepEmail = OnboardingStepEmail(vm: vm)
        let stepPassword = OnboardingStepPassword(vm: vm)
        
        loadedViews = [stepEmail, stepPassword]
    }
    
    func present(loadedView: UIView?, viewToRemove: UIView?) {
        guard let loadedView = loadedView else { return }
        containerView.addSubview(loadedView)
        
        loadedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadedView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            loadedView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            loadedView.topAnchor.constraint(equalTo: containerView.topAnchor),
            loadedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            ])
        
        loadedView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            loadedView.alpha = 1
            viewToRemove?.alpha = 0
        }, completion: { (completed: Bool) in
            viewToRemove?.removeFromSuperview()
        })
    }
    
    @IBAction func tapNext(_ sender: Any) {
        if !valid(at: step) { return }
        step += 1
        present(loadedView: loadedViews[step], viewToRemove: loadedViews[step - 1])
    }
    
    @IBAction func tapBack(_ sender: Any) {
        step -= 1
        present(loadedView: loadedViews[step], viewToRemove: loadedViews[step + 1])
    }
    
    func valid(at step: Int) -> Bool {
        return loadedViews[step].isValidStep
    }
    
    
    
    func login() {
        
    }


}
