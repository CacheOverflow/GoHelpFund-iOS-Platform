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
        let step2 = CreateCampaignStep2()
        let step3 = CreateCampaignStep3(delegate: self)
        
        //loadedViews = [step1, step2, step3]
        loadedViews = [step3]
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
        //barButton.isEnabled = false
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
        if !valid(at: step) { return }
        
        if step == nrSteps - 1 {
            finishCreateCampaign()
            return
        }
        
        step += 1
        present(loadedView: loadedViews[step], viewToRemove: loadedViews[step - 1])
    }
    
    func valid(at step: Int) -> Bool {
        return loadedViews[step].isValidStep
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
    
    func updateWithLocation(location: String) {
        if let step3 = loadedViews[0] as? CreateCampaignStep3 {
            step3.update(with: location)
        }
    }
    
    func getCurrentLocation() {
        guard let latitude: CLLocationDegrees = locationManager.location?.coordinate.latitude else { return }
        guard let longitude: CLLocationDegrees = locationManager.location?.coordinate.longitude else { return }
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            guard let placemark = placemarks?.first else { return }
            guard let city = placemark.locality else {
                if let country = placemark.country {
                    self.updateWithLocation(location: country)
                }
                return
            }
            
            guard let country = placemark.country else {
                if let city = placemark.locality {
                    self.updateWithLocation(location: city)
                }
                return
            }
            
            let location = city + ", " + country
            self.updateWithLocation(location: location)
        })
    }
}

extension CreateCampaignVC: CLLocationManagerDelegate {    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            getCurrentLocation()
        default:
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
        if let address = place.formattedAddress {
            updateWithLocation(location: address)
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
