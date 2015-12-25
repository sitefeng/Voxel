//
//  HNMainNavigationController.swift
//  HackTheNorth
//
//  Created by Si Te Feng on 8/19/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit


class HNMainNavigationController: UINavigationController, HNDrawerViewControllerDelegate, HNAbstractViewControllerDelegate {

    var drawerVC: HNDrawerViewController?
    
    var shouldShowLogin: Bool = false
    var shouldShowMentors: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set navigation bar tint color
        self.navigationBar.barTintColor = UIColor(colorType: HNColorTypes.NavigationBarColor)
        self.navigationBar.tintColor = UIColor.whiteColor()
        let font = UIFont(name: "Helvetica-Bold", size: 18)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName :UIColor.whiteColor(), NSFontAttributeName: font!]

        // Do any additional setup after loading the view.
        let mainViewController: FVHomeViewController! = FVHomeViewController(nibName:"FVHomeViewController", bundle: nil)
        mainViewController.delegate = self
        self.viewControllers = [mainViewController]
        
    }
    
    
    override func viewWillAppear(animated: Bool) {

        // Add Drawer VC as soon as viewWillAppear, (screenSize not determined at viewDidLoad)
        let drawerVC = HNDrawerViewController(nibName: "HNDrawerViewController", bundle: nil)
        drawerVC.delegate = self
        drawerVC.view.clipsToBounds = true
        drawerVC.view.frame = self.view.frame
        drawerVC.view.frame = CGRectApplyAffineTransform(drawerVC.view.bounds, CGAffineTransformMakeTranslation(-drawerVC.view.bounds.size.width, 0))
        self.view.addSubview(drawerVC.view)
        self.drawerVC = drawerVC
    }
    

    // MARK: Private Methods
    func switchToHeaderIndex(index: Int) {
        // Switch to the appropriate view controller
        switch index {
        case 0: // Home
            let mainViewController: FVHomeViewController! = FVHomeViewController(nibName:"FVHomeViewController", bundle: nil)
            mainViewController.delegate = self
            self.viewControllers = [mainViewController]
            
        case 1: // MyPattern
            let myPatternVC = FVMyPatternViewController(nibName: "FVMyPatternViewController", bundle: NSBundle.mainBundle())
            myPatternVC.delegate = self
            self.viewControllers = [myPatternVC]
            
        case 2: // PreloadedPattern
            let preloadedPatternVC = FVPreloadedPatternViewController(nibName: "FVPreloadedPatternViewController", bundle: NSBundle.mainBundle())
            preloadedPatternVC.delegate = self
            self.viewControllers = [preloadedPatternVC]
            
        case 3: // Connection
            let connectionVC = FVConnectionViewController(nibName: "FVConnectionViewController", bundle: NSBundle.mainBundle())
            connectionVC.delegate = self
            self.viewControllers = [connectionVC]
            
        case 4: // Camera
            let cameraVC = FVCameraViewController(nibName: "FVCameraViewController", bundle: NSBundle.mainBundle())
            cameraVC.delegate = self
            
            // TODO
            
        case 5: // Settings
            let settingsVC = FVSettingsViewController(nibName: "FVSettingsViewController", bundle: NSBundle.mainBundle())
            settingsVC.delegate = self
            self.viewControllers = [settingsVC]
            
        default:
            print("No Action Implemented")
            
        }
    }

    

    // MARK: Callback Methods
    func navDrawerButtonPressed(sender: UIButton) {
        showNavigationDrawer()
    }
    
    func showNavigationDrawer() {
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.drawerVC?.view.frame = CGRect(x: 0, y: self.drawerVC!.view.frame.origin.y, width: self.drawerVC!.view.frame.size.width, height: self.drawerVC!.view.frame.size.height)
        })
    }
    
    func retractNavigationDrawer() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.drawerVC?.view.frame = CGRect(x: -self.drawerVC!.view.frame.size.width, y: self.drawerVC!.view.frame.origin.y, width: self.drawerVC!.view.frame.size.width, height: self.drawerVC!.view.frame.size.height)
        })
    }
    
    
    // MARK:- HNDrawerViewController Delegate 
    
    func drawerViewController(controller: HNDrawerViewController, retractDrawerWithSelectedHeaderIndex index: Int?) {
        
        if index == nil {
            retractNavigationDrawer()
            return
        }
        
        self.switchToHeaderIndex(index!)
        retractNavigationDrawer()
    }
    
    // MARK - HNAbstractViewController Delegate
    func abstractViewController(controller: HNAbstractViewController, switchToHeaderIndex index: Int) {
        self.switchToHeaderIndex(index)
    }
    
    
    func drawerViewControllerReopenDrawerToFullPosition(controller: HNDrawerViewController) {
        showNavigationDrawer()
    }
    
    
    // Memory Warning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    
    
}
