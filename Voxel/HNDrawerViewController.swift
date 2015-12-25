//
//  HNDrawerViewController.swift
//  HackTheNorth
//
//  Created by Si Te Feng on 8/19/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit

protocol HNDrawerViewControllerDelegate {
    func drawerViewController(controller: HNDrawerViewController, retractDrawerWithSelectedHeaderIndex index: Int?)
    func drawerViewControllerReopenDrawerToFullPosition(controller: HNDrawerViewController)
}

class HNDrawerViewController: UIViewController {
    
    var delegate: HNDrawerViewControllerDelegate?
    var headerTitles: [String] = ["HOME", "MY PATTERNS", "VOXEL PATTERNS", "CONNECTION", "CAMERA", "SETTINGS"] {
        didSet {
            var count = 0
            for button in headerButtons {
                button.setTitle(headerTitles[count], forState: UIControlState.Normal)
                count++
            }
        }
    }
    
    var headerButtons: [UIButton] = []
    
    // Var for panGestureRecognizers
    var originX: CGFloat = 0
    var width: CGFloat = 0
    
    @IBOutlet weak var emptySpace: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        self.backgroundView.backgroundColor = UIColor.blackColor()
        
        
        self.scrollView.showsVerticalScrollIndicator = false
        
        //Adding move drawer function
        let panGestureRec = UIPanGestureRecognizer(target: self, action: "drawerPanned:")
        self.view.addGestureRecognizer(panGestureRec)
        
        let tapGestureRec = UITapGestureRecognizer(target: self, action: "emptySpaceTapped:")
        self.emptySpace.addGestureRecognizer(tapGestureRec)

        // Create Buttons
        var yPos: CGFloat = 10
        var count: Int = 0
        
        for header in headerTitles {
            let button = NSBundle.mainBundle().loadNibNamed("HNDrawerButton", owner: self, options: nil)[0] as! HNDrawerButton
            button.setTitle(header, forState: UIControlState.Normal)
            
            // Enable Notification Dot
            button.setNotification(true)
            button.frame = CGRect(x: 30, y: yPos, width: 200, height: 40)
            button.addTarget(self, action: "headerPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = count
            
            self.headerButtons.append(button)
            self.scrollView.addSubview(button)
            
            yPos += 50
            count++
        }
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: yPos)
    }
    
    override func viewDidLayoutSubviews() {
        var yPos: CGFloat = 60
        
        for button in self.headerButtons {
            button.frame = CGRect(x: 30, y: yPos, width: 200, height: 40)
            yPos += 50
        }
    }

    func headerPressed(button: HNDrawerButton) {
        self.delegate?.drawerViewController(self, retractDrawerWithSelectedHeaderIndex: button.tag)
    }
    
    
    func drawerPanned(rec: UIPanGestureRecognizer) {
        
        if (rec.state == UIGestureRecognizerState.Began) {
            self.originX  = self.view.frame.origin.x
            self.width = self.view.frame.size.width
            
        } else if (rec.state == UIGestureRecognizerState.Changed) {
            
            self.view.frame.origin.x = min(0, self.originX + rec.translationInView(self.view).x)
            
        } else if (rec.state == UIGestureRecognizerState.Ended) {
            if (self.originX + rec.translationInView(self.view).x > -self.width/3) {
                self.delegate?.drawerViewControllerReopenDrawerToFullPosition(self)
            } else {
                self.delegate?.drawerViewController(self, retractDrawerWithSelectedHeaderIndex: nil)
            }
            
        }
        
    }
    
    
    func emptySpaceTapped(rec: UITapGestureRecognizer) {
        if (rec.state == UIGestureRecognizerState.Ended) {
            self.delegate?.drawerViewController(self, retractDrawerWithSelectedHeaderIndex: nil)
        }
    }
    

}
