//
//  OnboardingVC.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 11/12/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit

enum OnboardingType {
    case createAccount
    case login
}

class OnboardingVC: UIViewController {
    var onboardingType = OnboardingType.createAccount
    //vm for extracting data
    var vm = OnboardingVM()

    //views
    @IBOutlet var containerView: UIView!
    var loadedViews = [NibView]()
    
    @IBOutlet var previousButton: UIButton!
    @IBOutlet var finishButton: HelpButton!
    @IBOutlet var finishView: UIView!
    
    @IBOutlet var nextView: UIView!
    
    @IBOutlet var loginView: UIView!
    @IBOutlet var createAccountView: UIView!
    //steps
    @objc dynamic var step: Int = 0
    var stepObserver: NSKeyValueObservation!
    var nrSteps: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialViews()
        
        setupKVO()
        setupLoadedViews()
        present(loadedView: loadedViews.first, viewToRemove: nil)
    }
    
    func setupInitialViews() {
        createAccountView.isHidden = false
        loginView.isHidden = false
        finishView.isHidden = true
        previousButton.isHidden = true
        nextView.isHidden = true
    }

    fileprivate func setupViewForLastStep() {
        previousButton.isHidden = false
        finishView.isHidden = false
        nextView.isHidden = true
        createAccountView.isHidden = true
        loginView.isHidden = true
    }
    
    fileprivate func setupViewForMiddleStep() {
        //middle
        createAccountView.isHidden = true
        loginView.isHidden = true
        
        previousButton.isHidden = false
        nextView.isHidden = false
        finishView.isHidden = true
    }
    
    func setupKVO() {
        stepObserver = observe(\.step, options: [.new, .old], changeHandler: { (_, change) in
            guard let nextStep = change.newValue else { return }
            if  nextStep == self.nrSteps - 1 {
                self.setupViewForLastStep()
               // last
            } else if nextStep == 0 {
                //first
                self.setupInitialViews()
            } else {
                self.setupViewForMiddleStep()
            }

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
    
    @IBAction func tapCreateAccount(_ sender: Any) {
        //present only create account because
        if !valid(at: step) { return }
        
        setupForCreateAccount()
        
        step += 1
        present(loadedView: loadedViews[step], viewToRemove: loadedViews[step - 1])
    }
    
    func setupForCreateAccount() {
        onboardingType = .createAccount
        nrSteps = 3
        loadedViews.append(OnboardingStepFullName(vm: vm))
        
    }
    
    @IBAction func tapLogin(_ sender: Any) {
        setupForLogin()
        
        step += 1
        present(loadedView: loadedViews[step], viewToRemove: loadedViews[step - 1])
    }
    
    func setupForLogin() {
        loadedViews.removeLast()

        onboardingType = .login
        nrSteps = 2
    }
    
    @IBAction func tapFinish(_ sender: Any) {
        if !valid(at: step) { return }
        
        if onboardingType == .login {
            login()
        } else {
            signUp()
        }
    }
    
    func login() {
        let onboardingService = AuthService()
        onboardingService.login(email: vm.email!, password: vm.password!, success: {
            //success
        }) {
        }
    }
    
    func signUp() {
        let onboardingService = AuthService()
        onboardingService.signUp(email: vm.email!, password: vm.password!, fullName: vm.fullName!, success: {
            //success
        }) {
            
        }
        
    }

    
    func valid(at step: Int) -> Bool {
        return loadedViews[step].isValidStep
    }

}
