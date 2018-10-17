//
//  CampaignVC.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 7/31/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit
import GooglePlaces
import YPImagePicker
import AVFoundation
import AVKit
import AWSS3
import SwiftSpinner


class CreateCampaignVC: UIViewController {
    //vm for extracting data
    var vm = CreateCampaignVM()
    
    //create Location Manager to handle the location
    let locationManager = CLLocationManager()
    
    //media
    var selectedImages = [YPMediaItem]()
    var uploadInfo: UploadInfo! = nil
    
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
        
        setupNavigationBar()
        setupSteps()
        setupKVO()
        setupLocation()
        setupLoadedViews()
        present(loadedView: loadedViews.first, viewToRemove: nil)
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
    
    func setupLoadedViews() {
        let step1 = CreateCampaignStep1(vm: vm)
        let step2 = CreateCampaignStep2(vm: vm)
        let step3 = CreateCampaignStep3(delegate: self, vm: vm)
        let step4 = CreateCampaignStep4(delegate: self)
        
        loadedViews = [step1, step2, step3, step4]
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
        navigationItem.hidesBackButton = true
        
        let barButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(tapCancel))
        navigationItem.title = "CREATE CAMPAIGN"
        navigationItem.leftBarButtonItems = [barButton]
    }

    @objc func tapCancel() {
        presentDashboard()
    }
    
    func presentCampaignDetails(campaign: Campaign) {
        let navigator = CampaignListNavigationFactory()
        let nextVC = navigator.createCampaignDetails(campaign: campaign)
        nextVC.isPresentedModally = true
        
        let nav = UINavigationController(rootViewController: nextVC)
        navigationController?.present(nav, animated: true, completion: nil)
    }
    
    func presentDashboard() {
        let navigator = CampaignListNavigationFactory()
        let nextVC = navigator.createDashboard()
        
        UIApplication.shared.keyWindow?.rootViewController = nextVC
    }
    
    @IBAction func tapPrevious(_ sender: Any) {
        step -= 1
        present(loadedView: loadedViews[step], viewToRemove: loadedViews[step + 1])
    }
    
    @IBAction func tapNext(_ sender: Any) {
        if !valid(at: step) { return }
        step += 1
        present(loadedView: loadedViews[step], viewToRemove: loadedViews[step - 1])
    }
    
    func valid(at step: Int) -> Bool {
        return loadedViews[step].isValidStep
    }

    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func updateWithLocation(location: String) {
        if let step3 = loadedViews[2] as? CreateCampaignStep3 {
            step3.update(with: location)
        }
    }
    
    func updateWithMediaCount(count: Int) {
        if let step4 = loadedViews[3] as? CreateCampaignStep4 {
            step4.updateItems(count: count)
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
    
    @IBAction func tapFinish(_ sender: Any) {
        if selectedImages.count > 0 {
            SwiftSpinner.show("Uploading images and creating the campaign...")
            uploadSelectedImages()
        } else {
            SwiftSpinner.show("Creating the campaign...")
            finishCreatingCampaign()
        }
    }
    
    func uploadSelectedImages() {
        let group = DispatchGroup()
        for (_, item) in selectedImages.enumerated() {
            group.enter()
            switch item {
            case .photo(let photo):
                self.uploadImage(image: photo.image, completed: {
                    group.leave()
                })
            case .video(let video):
                self.uploadVideo(video: video.url, completed: {
                    group.leave()
                })
            }
        }
        
        group.notify(queue: DispatchQueue.global(qos: .default)) {
            DispatchQueue.main.async {
                self.finishCreatingCampaign()
            }
        }
    }
    
    func finishCreatingCampaign() {
        let campaign = Campaign(vm: vm)
        let service = CampaignService()
        service.createCampaign(campaign: campaign, success: { (campaign) in
            SwiftSpinner.hide()
            self.presentCampaignDetails(campaign: campaign)
        }) {
            SwiftSpinner.hide()
            
            //handle error creating campaign
        }
    }
    
    func uploadVideo(video: URL, completed: () -> ()) {}
    
    func uploadImage(image: UIImage, completed: @escaping () -> ()) {
        let awsService = AwsUploadService()
        awsService.uploadImage(image: image, success: { (mediaResource) in
            self.vm.updateForStep4(mediaResource: mediaResource)
            completed()
        }) {
            completed()
            //handle failure
        }
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

extension CreateCampaignVC: CreateCampaignStep3Delegate {
    func didTapLocation() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}

extension CreateCampaignVC: CreateCampaignStep4Delegate {
    
    func didTapSkip() {
        finishCreatingCampaign()
    }
    
    func didTapUploadMedia() {
        clearExistingMediaAssets()
        showPicker()
    }
    
    func clearExistingMediaAssets() {
        selectedImages.removeAll()
        vm.resourcesUrl.removeAll()
    }
    
    func didTapShowSelected() {
        let gallery = YPSelectionsGalleryVC.initWith(items: selectedImages) { g, _ in
            g.dismiss(animated: true, completion: nil)
        }
        let navC = UINavigationController(rootViewController: gallery)
        self.present(navC, animated: true, completion: nil)
    }
    
    // MARK: - Configuration
    func showPicker() {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photoAndVideo
        config.albumName = "Go Help Fund"
        config.startOnScreen = .library
        config.screens = [.library, .photo]
        config.video.libraryTimeLimit = 300.0
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        config.library.maxNumberOfItems = 4
        //config.library.skipSelectionsGallery = true

        let picker = YPImagePicker(configuration: config)

        /* Multiple media implementation */
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            
            self.selectedImages = items
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    self.didFinishSelecting(items: items)
                    picker.dismiss(animated: true, completion: nil)
                case .video(let video):
                    self.updateWithMediaCount(count: items.count)
                    let assetURL = video.url
                    let playerVC = AVPlayerViewController()
                    let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
                    playerVC.player = player
                    
                    picker.dismiss(animated: true, completion: { [weak self] in
                        self?.present(playerVC, animated: true, completion: nil)
                    })
                }
            }
        }
        present(picker, animated: true, completion: nil)
    }
    
    func didFinishSelecting(items: [YPMediaItem]) {
        self.finishButton.isHidden = false
        self.updateWithMediaCount(count: items.count)
    }
}

extension CreateCampaignVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if let address = place.formattedAddress {
            updateWithLocation(location: address)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {}
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {}
}
