//
//  HNAbstractViewController.swift
//  HackTheNorth
//
//  Created by Si Te Feng on 8/19/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

// For All View Controllers that requires the left Navigation button to pull out the navigation drawer, USE THIS CLASS AS PARENT CLASS

import UIKit

protocol HNAbstractViewControllerDelegate {
    func abstractViewController(controller: HNAbstractViewController, switchToHeaderIndex index: Int)
}

class HNAbstractViewController: UIViewController {
    
    var delegate: HNAbstractViewControllerDelegate?
    var defaultAlertController: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create navigation drawer button
        let navDrawerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        navDrawerButton.setBackgroundImage(UIImage(named: "drawerIcon"), forState: UIControlState.Normal)
        navDrawerButton.addTarget(self.navigationController, action: "navDrawerButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        let navDrawerNavItem = UIBarButtonItem(customView: navDrawerButton)
        self.navigationItem.leftBarButtonItem = navDrawerNavItem
        
        // UITabBar Font
        let font = UIFont(name: "Helvetica", size: 8)
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: font!], forState: UIControlState.Normal)
    }
    
    // MARK: - Showing/Hiding Child View Controllers
    
    func retractChildViewController(vc: UIViewController) {
        let vcHiddenFrame = CGRect(x: 0, y: 1000, width: vc.view.frame.size.width, height: vc.view.frame.size.height)
        
        vc.willMoveToParentViewController(nil)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            vc.view.frame = vcHiddenFrame
            
            
        }) { (finished) -> Void in
            vc.removeFromParentViewController()
            vc.view.removeFromSuperview()
        }
        
    }
    
    func showChildViewController(vc: UIViewController) {
        let vcHiddenFrame = CGRect(x: 0, y: 1000, width: vc.view.frame.size.width, height: vc.view.frame.size.height)
        
        self.addChildViewController(vc)
        vc.view.frame = vcHiddenFrame
        self.view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            vc.view.frame = self.view.bounds
            
        }) { (finished) -> Void in
            
        }
    }
    
    
    // MARK: Convenience Functions
    func showAlert(title: String, message: String) {
        defaultAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        defaultAlertController.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
        
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "dismissAlert", userInfo: nil, repeats: false)
        self.presentViewController(self.defaultAlertController, animated: true, completion: nil)
    }
    
    func dismissAlert() {
        if self.defaultAlertController != nil {
            self.defaultAlertController.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    
}
