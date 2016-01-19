//
//  FVSetLEDsModuleViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 1/9/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

protocol FVSetLEDsModuleViewControllerDelegate {
    func setLEDsModuleViewController(controller: FVSetLEDsModuleViewController, newColorArray: [UIColor])
    func numberOfLEDsPerModule() -> Int
}

// Responsible for only ONE LED module
class FVSetLEDsModuleViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet private weak var moduleLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    var ledImageView: UIImageView!
    var ledFrameView: UIImageView!
    
    var panRec: UIPanGestureRecognizer!
    var longPressRec: UILongPressGestureRecognizer!
    
    // Public Variables
    var delegate: FVSetLEDsModuleViewControllerDelegate?
    
    var labelTitle: String? {
        didSet {
            if self.moduleLabel != nil {
                self.moduleLabel.text = labelTitle
            }
        }
    }
    
    // Constants
    let margin = CGFloat(34)

    let ledHeight = CGFloat(60)
    var ledWidth: CGFloat {
        get {
            return CGFloat(ledHeight)/4
        }

    }
    
    // Variables
    var ledColorArray: [UIColor] = []
    var currBrushColor: UIColor = UIColor.whiteColor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moduleLabel.text = labelTitle
        
        // Gesture Recognizer
        self.panRec = UIPanGestureRecognizer(target: self, action: "drawOnLEDRecognized:")

        self.longPressRec = UILongPressGestureRecognizer(target: self, action: "longPressRecognized:")
        longPressRec.minimumPressDuration = 0.0
        longPressRec.requireGestureRecognizerToFail(self.panRec)

        // Update Variables
        let numberOfLEDs = self.delegate?.numberOfLEDsPerModule() as Int!
        for _ in 0 ..< numberOfLEDs {
            self.ledColorArray.append(UIColor.clearColor())
        }
        
        // Setup Set LED Drawing Views, add to scrollview
        let imageViewWidth = ledWidth * CGFloat(numberOfLEDs)
        
        self.ledImageView = UIImageView(frame: CGRect(x: margin, y: margin, width: imageViewWidth, height: ledHeight))
        self.ledImageView.userInteractionEnabled = true
        self.ledImageView.addGestureRecognizer(panRec)
        self.ledImageView.addGestureRecognizer(longPressRec)
        
        self.ledFrameView = UIImageView(frame: self.ledImageView.frame)
        
        self.scrollView.contentSize = CGSize(width: imageViewWidth + 2*margin, height: self.scrollView.frame.size.height)
        self.scrollView.addSubview(self.ledImageView)
        self.scrollView.addSubview(self.ledFrameView)
        
        // Draw LED Frame
        self.drawLEDFrame(numberOfLEDs)
    }
    
    
    func drawLEDFrame(numberOfLEDs: Int) {
        self.ledFrameView.image = nil
        
        let frameLineWidth = CGFloat(1)
        
        UIGraphicsBeginImageContext(self.ledFrameView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        let strokeColor = UIColor(colorType: HNColorTypes.SecondaryTextColor)
        CGContextSetStrokeColorWithColor(context, strokeColor?.CGColor)
        
        var xPos = CGFloat(0)
        
        for _ in 0 ..< numberOfLEDs {
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
            self.drawLEDColorRectForXPos(pt.x)
            
        case .Changed:
            
            let xTranslation = rec.translationInView(self.ledImageView).x
            let currXPos = panBeginXPos + xTranslation
            
            self.drawLEDColorRectForXPos(currXPos)
            
        default:
            break
        }
    }
    
    
    func longPressRecognized(rec: UILongPressGestureRecognizer) {
        
        let pt = rec.locationInView(self.ledImageView)
        
        if rec.state == UIGestureRecognizerState.Began {
            self.drawLEDColorRectForXPos(pt.x)
        }
    }
    
    // Updates both the Model and View of this view controller
    func drawLEDColorRectForXPos(xPos: CGFloat) {
        let numberOfLEDs = self.delegate?.numberOfLEDsPerModule() as Int!
        
        let colorArrayBefore = self.ledColorArray
        
        // Drawing on screen
        UIGraphicsBeginImageContext(self.ledImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        self.ledImageView.image?.drawInRect(self.ledImageView.bounds)
        
        let ledIndex = min(max( floor(xPos / ledWidth), 0), CGFloat(numberOfLEDs-1))
        let ledRectXPos = ledIndex * ledWidth
        
        CGContextSetFillColorWithColor(context, self.currBrushColor.CGColor)
        CGContextFillRect(context, CGRect(x: ledRectXPos, y: 0, width: ledWidth, height: ledHeight))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        self.ledImageView.image = image
        
        // For Delegate
        self.ledColorArray[Int(ledIndex)] = self.currBrushColor
        if (self.ledColorArray != colorArrayBefore) {
            self.delegate?.setLEDsModuleViewController(self, newColorArray: self.ledColorArray)
        }
    }
    
    
    func clearAllLEDs() {
        ledColorArray = []
        let numberOfLEDs = self.delegate?.numberOfLEDsPerModule()
        
        for _ in 0 ..< numberOfLEDs! {
            ledColorArray.append(UIColor.blackColor())
        }
        
        self.ledImageView.image = nil
    }
    
    
    // MARK: Gesture Recognizer Delegate
    // TODO: Remove, not in use
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return (gestureRecognizer == self.panRec)
    }

    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == self.longPressRec && otherGestureRecognizer == self.panRec) ||
           (gestureRecognizer == self.panRec && otherGestureRecognizer == self.longPressRec) {
            return true
        } else {
            return false
        }
    }



}

