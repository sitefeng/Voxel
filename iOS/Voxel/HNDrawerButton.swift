//
//  HNDrawerButton.swift
//  HackTheNorth
//
//  Created by Si Te Feng on 8/19/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit

class HNDrawerButton: UIButton, UIGestureRecognizerDelegate {

    private(set) var hasNotification: Bool?
    
    private var target: AnyObject?
    private var action: Selector?
    
    private var pressWasCancelled = false
    
    @IBOutlet weak var notifDot: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    
    override func setTitle(title: String?, forState state: UIControlState) {
        if state == UIControlState.Normal {
            self.mainLabel.text = title
        } else {
            print("Control State Not Supported")
        }
    
    }
    
    
    func setNotification(toActive: Bool!) {
        self.hasNotification = toActive
        if (self.hasNotification == true) {
            notifDot.image = UIImage(named: "orangeDot")
        } else {
            notifDot.image = nil
        }
    }
    
    override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        super.addTarget(target, action: action, forControlEvents: controlEvents)
        
        self.target = target
        self.action = action
        
        self.backgroundColor = UIColor.clearColor()
        
        let longRec = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        longRec.minimumPressDuration = 0
        longRec.delegate = self
        self.addGestureRecognizer(longRec)
        
    }
    
    
    func longPressed(rec: UILongPressGestureRecognizer) {
        if (rec.state == UIGestureRecognizerState.Began) {
            self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
            self.pressWasCancelled = false
        
        } else if (rec.state == UIGestureRecognizerState.Ended) {
            self.backgroundColor = UIColor.clearColor()
            
            if !self.pressWasCancelled {
                UIApplication.sharedApplication().sendAction(action!, to: target, from: self, forEvent: nil)
            }
            
        } else {
            self.pressWasCancelled = true
            self.backgroundColor = UIColor.clearColor()
        }
    }
    
    // MARK: Long Press Gesture Recognizer Delegate
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
