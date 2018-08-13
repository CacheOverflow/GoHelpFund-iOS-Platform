//
//  CampaignVC.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 7/31/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit

class CreateCampaignVC: UIViewController {
    @IBOutlet var containerView: UIView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var previousButton: UIButton!
    
    let step1 = CreateCampaignStep1()
    let step2 = CreateCampaignStep2()
    let step3 = CreateCampaignStep3()
    var views = [NibView]()
    
    var loadedViews = [UIView]()
    
    var step: Int = 0
    var nrSteps: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        setupLoadedViews()
        setupNavigationBar()
        present(loadedView: loadedViews.first, viewToRemove: nil)
    }
    
    func setupLoadedViews() {
        views = [step1, step2, step3]
        loadedViews = views.map { $0.loadNib() }
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

    func setupNavigationBar() {
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(tapDone))
        navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    @objc func tapDone() {
        let navigator = CampaignListNavigationFactory()
        let nextVC = navigator.createDashboard()
        
        UIApplication.shared.keyWindow?.rootViewController = nextVC
    }
    
    @IBAction func tapPrevious(_ sender: Any) {
        if step == 0 {
            return
        }
        
        step -= 1
        present(loadedView: loadedViews[step], viewToRemove: loadedViews[step + 1])
    }
    
    @IBAction func tapNext(_ sender: Any) {
        valid(at: step)
        
        if step == nrSteps - 1 {
            finishCreateCampaign()
            return
        }
        
        step += 1
        present(loadedView: loadedViews[step], viewToRemove: loadedViews[step - 1])
    }
    
    func valid(at step: Int) {
        let v = CreateCampaignStep1()
        print(v.isValidStep)
        print(views[step].isValidStep)
    }
    
    func retriveData() {
        print(step1.title)
    }
    
    func finishCreateCampaign() {
        retriveData()
    }
}

protocol StepValidator {
    var isValidStep: Bool { get }
}
