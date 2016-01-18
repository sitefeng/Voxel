//
//  FVSetLEDsModuleViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 1/9/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

// Responsible for only ONE LED module
class FVSetLEDsModuleViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // Constants
    let margin = CGFloat(8)

    @IBOutlet private weak var moduleLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    var ledImageView: UIImageView!
    var ledFrameView: UIImageView!
    
    var panRec: UIPanGestureRecognizer!
    
    // Public Variables
    var numberOfLEDs = 57
    var ledHeight = CGFloat(40)
    var ledWidth: CGFloat {
        get {
            return CGFloat(ledHeight)/4
        }

    }
    var ledColorArray: [UIColor] = []
    var currBrushColor: UIColor = UIColor.blackColor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gesture Recognizer
        self.panRec = UIPanGestureRecognizer(target: self, action: "drawOnLEDRecognized")

        // Update Variables
        for i in 0 ..< numberOfLEDs {
            self.ledColorArray.append(UIColor.clearColor())
        }
        
        // Setup Set LED Drawing Views, add to scrollview
        let imageViewWidth = ledWidth * CGFloat(numberOfLEDs)
        
        self.ledImageView = UIImageView(frame: CGRect(x: margin, y: margin, width: imageViewWidth, height: ledHeight))
        self.ledImageView.userInteractionEnabled = true
        self.ledImageView.addGestureRecognizer(panRec)
        
        self.ledFrameView = UIImageView(frame: self.ledImageView.frame)
        
        self.scrollView.contentSize = CGSize(width: imageViewWidth + 2*margin, height: self.scrollView.frame.size.height)
        self.scrollView.addSubview(self.ledImageView)
        self.scrollView.addSubview(self.ledFrameView)
        
    }
    
    
    func drawLEDFrame() {
        self.ledFrameView.image = nil
        
        let frameLineWidth = CGFloat(1)
        
        UIGraphicsBeginImageContext(self.ledFrameView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        let strokeColor = UIColor(colorType: HNColorTypes.SecondaryTextColor)
        CGContextSetStrokeColorWithColor(context, strokeColor?.CGColor)
        
        var xPos = CGFloat(0)
        
        for _ in 0 ..< self.numberOfLEDs {
            CGContextStrokeRectWithWidth(context, CGRect(x: xPos, y: 0, width: ledWidth, height: ledHeight), frameLineWidth)
            
            xPos += ledWidth
        }
        
        ledFrameView.image = UIGraphicsGetImageFromCurrentImageContext()
    }

    
    var panBeginXPos = CGFloat(0)
    
    
    func drawOnLEDRecognized(rec: UIPanGestureRecognizer) {
        
        let pt = rec.locationInView(self.ledImageView)
        
        switch(rec.state) {
        case .Began:
            panBeginXPos = pt.x
            
        case .Changed:
            let xTranslation = rec.translationInView(self.ledImageView).x
            let currXPos = panBeginXPos + xTranslation
            
            self.drawLEDColorRectForXPos(currXPos)
            
        case .Ended:
            panBeginXPos = CGFloat(0)
            
        default:
            break
        }
    }
    
    
    // Updates both the Model and View of this view controller
    func drawLEDColorRectForXPos(xPos: CGFloat) {
        
        UIGraphicsBeginImageContext(self.ledImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        self.ledImageView.image?.drawInRect(self.ledImageView.bounds)
        
        let ledIndex = floor(xPos / ledWidth)
        let ledRectXPos = ledIndex * ledWidth
        
        CGContextSetFillColorWithColor(context, self.currBrushColor.CGColor)
        CGContextFillRect(context, CGRect(x: ledRectXPos, y: 0, width: ledWidth, height: ledHeight))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        self.ledImageView.image = image
    }
    
    
    func clearAllLEDs() {
        self.ledImageView.image = nil
    }
    
    
    // MARK: Gesture Recognizer Delegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return (gestureRecognizer == self.panRec)
    
    }
    
    



}

