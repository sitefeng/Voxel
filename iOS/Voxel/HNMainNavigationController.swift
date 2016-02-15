//
//  HNMainNavigationController.swift
//  HackTheNorth
//
//  Created by Si Te Feng on 8/19/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit


class HNMainNavigationController: FVNavigationController, HNDrawerViewControllerDelegate, HNAbstractViewControllerDelegate {

    var drawerVC: HNDrawerViewController?
    
    var shouldShowLogin: Bool = false
    var shouldShowMentors: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status bar
        self.setNeedsStatusBarAppearanceUpdate()
        
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
//            let connectionVC = FVConnectionViewController(nibName: "FVConnectionViewController", bundle: NSBundle.mainBundle())
//            connectionVC.delegate = self
//            self.viewControllers = [connectionVC]
            
            openURL2()
            
        case 4: // Camera
            let cameraVC = FVCameraViewController(nibName: "FVCameraViewController", bundle: NSBundle.mainBundle())
            cameraVC.delegate = self
            
            openURL1()
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
    
    // MARK - HNAbstractViewController Delegate Methods
    func abstractViewController(controller: HNAbstractViewController, switchToHeaderIndex index: Int) {
        self.switchToHeaderIndex(index)
    }
    
    
    func drawerViewControllerReopenDrawerToFullPosition(controller: HNDrawerViewController) {
        showNavigationDrawer()
    }
    
    
    
    // Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    // Memory Warning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    
    
    func openURL1() {
        UIPasteboard.generalPasteboard().string = "192.168.4.1/300200020iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAACXBIWXMAAAsTAAALEwEAmpwYAAABWWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS40LjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyI+CiAgICAgICAgIDx0aWZmOk9yaWVudGF0aW9uPjE8L3RpZmY6T3JpZW50YXRpb24+CiAgICAgIDwvcmRmOkRlc2NyaXB0aW9uPgogICA8L3JkZjpSREY+CjwveDp4bXBtZXRhPgpMwidZAAADPklEQVQ4EY2Uy08TYRTFz3wzQGt5+goQjOVNdIEUBIJCQosP2mrjxmjcuPN/M77QAEJkNLDQEHn4J7gwIbyKFAK0zIznfjCxlErcTvP9eu655x7jsK3Hw7Mr8GrWYdyuhtm0h+nSEF4Ex3BjfhY/pwbxdMtB3VcXfZcUWjImnIpp4NdzGMl+eBfTMG5VwmzewherHkpg7nn5SFhLDnZpEI8Iu75gY2V8EI83HTTMu7h5QaF1z4QbsoHVezDi3fAu78AYKOe7fdgl1Rg+NwlLlKkBwloJs0zEgh8wujCD9NgwHmYcXF1wEalSaM9SWakNbyMGYyQOtzYH1V/Cdw7fWXz3HqnlaVh6TFGmYeOIE5Z5F0Vi10HjkouuSsJyhJUQliYsloBX70L1moR5fKcIG0dycQYbr6NQ4pltleiPGjYWxegOYYsOusoLYFHC6lwYvQbMtr8webf1lu+yDixZgHgmY4oyDVsSmHlSmcCorBhsm+/inKj5G38Pe/BkAeJZksrCVBYpAnOpTPWdVJagiG1OdJ/vmuh1Z5UBS6KxMjGoF6A9CxVXpoqMqWFcXJPvNSOlJGep31TGf9CeHeYt4AzPMqKMMC1CvN7nu6o5qCdpRuM7o1G4Td+zgjH9FAisiV5HBCaRCn6GtzIEVU8jIzX/t03xTJSN6kjlLU7yuRaFcScFS85JLkCHVnLmK/uHZ6N6zDyY5HNTwv4AXsMulL7NwPHHM2C+Z2FZQGEKdNhzQCQI5fLQvTW5gPg/c6bzebzNSKiIPTqfFqxr2zAOu+s8yKHzNo0+nlPeBfg5kzHDegF5kZIxY0lejsN3CmZ7FnOqnG0jFVR7cAom25Sc+Z6dCrvA6gXGsLcfwlZlGArMs22kz/pZQbo1jg49/6aLeqbzSZi/OJNtExhH6sdHKF2OrVkWhHFUEGwNuU05p8ZFRsrPmb9Nf3F6TKmuIxGJpU9Yf3mXbcOmta0AYRO6gralNZgzuc2uCi7ggJEKMLTSgzFGQ8aU6qJntsmWojKprvQbFoTjQEltx4KzLMcpbL0ibN9BC8PeWU3YDmGhOXirDO1IijnbA3pYqh0ZvYBY2TLHnEKa7xI5Bx2THv4AI4gaeNi6plMAAAAASUVORK5CYII="
    }
    
    
    func openURL2() {
        UIPasteboard.generalPasteboard().string = "192.168.4.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"
    }
    
    
    func openURL3() {
        UIPasteboard.generalPasteboard().string = "192.168.4.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"
        
    }
}
