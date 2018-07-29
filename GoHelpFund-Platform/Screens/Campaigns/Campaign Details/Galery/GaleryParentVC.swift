//
//  GaleryParentVC.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 7/2/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import UIKit

class GaleryParentVC: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    var nrPages : Int = 4
    var currentIndex : Int = 0
    var pageViewController : UIPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPageVC()
    }
    
    // MARK: - Setup
    
    func setupPageVC() {

        self.pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        self.pageViewController?.dataSource = self
        self.pageViewController?.delegate = self
        self.pageViewController?.view.frame = self.view.bounds
        
        let initialChild = viewControllerAtIndex(index: 0)
        
        pageViewController?.setViewControllers([initialChild], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        self.addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        
        self.pageViewController?.didMove(toParentViewController: self)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as? GaleryChildVC)?.index
        if index == 0 {
            return nil
        }
        index = index! - 1
        return viewControllerAtIndex(index: index!)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as? GaleryChildVC)?.index
        if index == nrPages {
            return nil
        }
        
        index = index! + 1
        return viewControllerAtIndex(index: index!)
        
    }
    
    func viewControllerAtIndex(index : Int) -> GaleryChildVC {
        
        let childVC = GaleryChildVC(nibName: "GaleryChildVC", bundle: nil)
        
        childVC.index = index
        return childVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let currentVC: GaleryChildVC = pageViewController.viewControllers![0] as! GaleryChildVC
        currentIndex = currentVC.index
        
    }

}
