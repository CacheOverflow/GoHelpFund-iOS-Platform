//
//  CategoriesVC.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 8/3/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit

let kInterItemSpacing: CGFloat = 5.0
let kNumberOfItemsPerLine = 3

class CategoriesVC: UIViewController {

    var vm: CategoriesVM = CategoriesVM()
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        displayCategories()
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

    func displayCategories() {
        vm.getCategories(success: {
            self.setupCollectionView()
        }) {
            //present empty categories screen
        }
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        CategoryCell.registerNibToCollectionView(collectionView: collectionView)
    }
}

extension CategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.categoriesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.cellReuseIdentifier(), for: indexPath) as? CategoryCell else { fatalError("wrong cell") }
        cell.setupWithVM(vm: vm.cellVM(at: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width
        let elementSize = Int(width - 2 * kInterItemSpacing) / kNumberOfItemsPerLine
        return CGSize(width: elementSize, height: elementSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let navigator = CampaignListNavigationFactory(storyboard: UIStoryboard(name: StoryboardIds.createCampaignStoryboardId.rawValue, bundle: nil))
        let nextVC = navigator.createCreateCampaign()
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
