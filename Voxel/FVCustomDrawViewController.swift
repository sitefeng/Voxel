//
//  FVCustomDrawViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 12/25/15.
//  Copyright © 2015 Si Te Feng. All rights reserved.
//

import UIKit

class FVCustomDrawViewController: HNAbstractViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    var brushColor = UIColor.whiteColor().CGColor
    var brushDiameter = CGFloat(4)
    
    // Convenience Variables
    var brushCurrPoint: CGPoint?
    var brushMoved = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Custom Draw"
        
        let dismissBarButton = UIBarButtonItem(title: "Dismiss", style: UIBarButtonItemStyle.Done, target: self, action: "dismissButtonPressed")
        self.navigationItem.leftBarButtonItem = dismissBarButton
        
        let sendBarButton = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Done, target: self, action: "sendButtonPressed")
        self.navigationItem.rightBarButtonItem = sendBarButton
        
        
        // Setup Brush Palette controller
        let brushPaletteController = FVBrushPaletteViewController(nibName: "FVBrushPaletteViewController", bundle: nil)
        brushPaletteController.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.size.height + 64 - 95, width: self.view.frame.size.width, height: 191)
        self.addChildViewController(brushPaletteController)
        self.view.addSubview(brushPaletteController.view)
        brushPaletteController.didMoveToParentViewController(self)
        
    }
    
    
    // MARK: Navigation Callback Methods
    
    func dismissButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
        return
    }
    
    func sendButtonPressed() {
        return
    }
    
        
    // MARK: Drawing Related Methods
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        brushMoved = false
        
        let currTouch = touches.first
        brushCurrPoint = currTouch?.locationInView(self.tempImageView)
        
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        brushMoved = true
        
        let currTouch = touches.first
        let newPoint = currTouch?.locationInView(self.tempImageView) as CGPoint!
        
        drawLine(brushCurrPoint!, pt2: newPoint, inRect: self.tempImageView.frame)
        
        brushCurrPoint = newPoint
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let currTouch = touches.first
        let endPoint = currTouch?.locationInView(self.tempImageView) as CGPoint!
        
        if brushMoved == false {
            drawPoint(endPoint, inRect: tempImageView.frame)
        }
        
        brushCurrPoint = nil
        
        // Move image from Temp Image View to Main one
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.drawInRect(mainImageView.bounds, blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(mainImageView.bounds, blendMode: CGBlendMode.Normal, alpha: 1.0)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        mainImageView.image = finalImage
        tempImageView.image = nil
    }
    
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        print("Cancelled")
        tempImageView.image = nil
    }
    
    
    func drawPoint(pt: CGPoint, inRect rect: CGRect) {
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        let ellipseRect = CGRect(x: pt.x - brushDiameter/2, y: pt.y - brushDiameter/2, width: brushDiameter, height: brushDiameter)
        
        CGContextSetFillColorWithColor(context, brushColor)
        CGContextFillEllipseInRect(context, ellipseRect)
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    func drawLine(pt1: CGPoint, pt2: CGPoint, inRect rect: CGRect) {
        
        UIGraphicsBeginImageContext(rect.size)
        tempImageView.image?.drawInRect(tempImageView.bounds, blendMode: CGBlendMode.Normal, alpha: 1.0)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextMoveToPoint(context, pt1.x, pt1.y)
        CGContextAddLineToPoint(context, pt2.x, pt2.y)
        
        CGContextSetStrokeColorWithColor(context, brushColor)
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brushDiameter)
        
        CGContextStrokePath(context)
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    
}
