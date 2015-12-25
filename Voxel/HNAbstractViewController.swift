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
    
}
