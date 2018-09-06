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

class CreateCampaignVC: UIViewController {
    let locationManager = CLLocationManager()
    var vm = CreateCampaignVM()
    var selectedImages = [YPMediaItem]()
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var previousButton: UIButton!
    @IBOutlet var finishButton: HelpButton!
    
    var loadedViews = [NibView]()
    
    var uploadInfo: UploadInfo! = nil
    
    @objc dynamic var step: Int = 0
    var stepObserver: NSKeyValueObservation!
    
    var nrSteps: Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        finishButton.isHidden = true
        
        getUploadData()
        
        navigationItem.hidesBackButton = true
        self.previousButton.isEnabled = false
        
        setupLocation()
        setupLoadedViews()
        setupNavigationBar()
        setupKVO()
        present(loadedView: loadedViews.first, viewToRemove: nil)
    }
    
    func setupKVO() {
        stepObserver = observe(\.step, options: [.new, .old], changeHandler: { (_, change) in
            if let nextStep = change.newValue {
                if nextStep == self.nrSteps - 1 {
                    self.nextButton.isEnabled = false
                } else {
                    self.nextButton.isEnabled = true
                }
                
                if nextStep == 0 {
                    self.previousButton.isEnabled = false
                } else {
                    self.previousButton.isEnabled = true
                }
            }
        })
    }
    
    func setupLoadedViews() {
        let step1 = CreateCampaignStep1(vm: vm)
        let step2 = CreateCampaignStep2(vm: vm)
        let step3 = CreateCampaignStep3(delegate: self, vm: vm)
        let step4 = CreateCampaignStep4(delegate: self)
        
        //loadedViews = [step1, step2, step3, step4]
        loadedViews = [step4]
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
        let barButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(tapCancel))
        navigationItem.title = "CREATE CAMPAIGN"
        navigationItem.rightBarButtonItems = [barButton]
    }

    @objc func tapCancel() {
        presentDashboard()
    }
    
    func presentCampaignDetails(campaign: Campaign) {
        
    }
    
    func presentDashboard() {
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
            return
        }
        
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
        if let step4 = loadedViews[0] as? CreateCampaignStep4 {
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
    
    func getUploadData() {
        let service = CampaignService()
        service.getMediaUploadData(success: { (uploadInfo) in
            self.uploadInfo = uploadInfo
        }) {
            //handle error no upload info
        }
    }
    
    @IBAction func tapFinish(_ sender: Any) {
        if selectedImages.count > 0 {
            uploadSelectedImages()
        } else {
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
            self.presentCampaignDetails(campaign: campaign)
        }) {
            //handle error creating campaign
        }
    }
    
    func uploadVideo(video: URL, completed: () -> ()) {
        
    }
    
    func uploadImage(image: UIImage, completed: @escaping () -> ()) {
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: uploadInfo.accessKeyID, secretKey: uploadInfo.accessKeySecret)
        
        let configuration = AWSServiceConfiguration(region: .EUCentral1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        //let randomPath = "offerImage" + String.random(ofLength: 5)
        
        //let urlImgOfferDir = URL(fileURLWithPath: NSTemporaryDirectory().appending(randomPath))
        
        
        let uuid = UUID().uuidString
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(uuid).jpeg")
        let imageData = UIImageJPEGRepresentation(image, 0)
        fileManager.createFile(atPath: path as String, contents: imageData, attributes: nil)
        
        //let fileUrl = NSURL(fileURLWithPath: path)
        let fileUrl =  URL(fileURLWithPath: NSTemporaryDirectory().appending("\(uuid).jpeg"))
       
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket = uploadInfo.bucketName
        uploadRequest?.key = "\(uuid).jpeg"
        uploadRequest?.contentType = "image/jpeg"
        uploadRequest?.body = fileUrl as URL!
        uploadRequest?.acl = .publicRead
        
        uploadRequest?.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
            DispatchQueue.main.async(execute: {
            })
        }
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            
            if task.result != nil {
                let url = AWSS3.default().configuration.endpoint.url
                let publicURL = url?.appendingPathComponent((uploadRequest?.bucket!)!).appendingPathComponent((uploadRequest?.key!)!)
                self.vm.updateForStep4(name: uploadRequest!.key!, url: publicURL!, type: "image", format: "jpeg")
            }
            
            completed()
            return nil
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
        showPicker()
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
