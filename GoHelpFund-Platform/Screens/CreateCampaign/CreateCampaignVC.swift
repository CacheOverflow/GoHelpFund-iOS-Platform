//
//  CampaignVC.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 7/31/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit
import GooglePlaces

class CreateCampaignVC: UIViewController {
    let locationManager = CLLocationManager()
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var previousButton: UIButton!
    
    var loadedViews = [NibView]()
    
    var step: Int = 0
    var nrSteps: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        setupLocation()
        setupLoadedViews()
        setupNavigationBar()
        present(loadedView: loadedViews.first, viewToRemove: nil)
    }
    
    func setupLoadedViews() {
        let step1 = CreateCampaignStep1()
        let step2 = CreateCampaignStep2(delegate: self)
        let step3 = CreateCampaignStep3()
        
        loadedViews = [step1, step2, step3]
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
        print(loadedViews[step].isValidStep)
    }
    
    func retriveData() {
        
    }
    
    func finishCreateCampaign() {
        
        let navigator = CampaignListNavigationFactory(storyboard: UIStoryboard(name: StoryboardIds.createCampaignStoryboardId.rawValue, bundle: nil))
        let nextVC = navigator.createMediaPicker()
        
        navigationController?.pushViewController(nextVC, animated: true)
        //UIApplication.shared.keyWindow?.rootViewController = nextVC
        
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentPlace() {
        GMSPlacesClient.shared().currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList.likelihoods {
                    let place = likelihood.place
                    print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                    print("Current Place address \(place.formattedAddress)")
                    print("Current Place attributions \(place.attributions)")
                    print("Current PlaceID \(place.placeID)")
                }
            }
        })
    }
}

extension CreateCampaignVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .restricted, .denied:
            // Disable your app's location features
            //disableMyLocationBasedFeatures()
            break
            
        case .authorizedWhenInUse:
            // Enable only your app's when-in-use features.
            //enableMyWhenInUseFeatures()
            getCurrentPlace()
            break
            
        case .authorizedAlways:
            // Enable any of your app's location services.
            //enableMyAlwaysFeatures()
            break
            
        case .notDetermined:
            break
        }
    }
}

extension CreateCampaignVC: CreateCampaignStep2Delegate {
    func didTapLocation() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}

extension CreateCampaignVC: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        
        print(place.coordinate)
        
        if let step2 = loadedViews[1] as? CreateCampaignStep2 {
            if let address = place.formattedAddress {
                step2.update(with: address)
            }
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

protocol StepValidator {
    var isValidStep: Bool { get }
}
