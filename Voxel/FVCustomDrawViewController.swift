//
//  FVCustomDrawViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 12/25/15.
//  Copyright © 2015 Si Te Feng. All rights reserved.
//

import UIKit

class FVCustomDrawViewController: HNAbstractViewController, FVBrushPaletteProtocolForCanvas {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    // Views
    var alertController: UIAlertController
    
    // Constants
    let paletteFullHeight = CGFloat(191)
#if TARGET_IPHONE_SIMULATOR
    let paletteRetractHeight = CGFloat(64 - 95)
#else
    let  paletteRetractHeight = CGFloat(95)
#endif
    
    // Variables
    var brushColor = UIColor.whiteColor().CGColor
    var brushDiameter = CGFloat(8)
    
    var brushType = FVBrushTypes.round
    
    
    // Private Convenience Variables
    var brushCurrPoint: CGPoint?
    var brushMoved = false

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    
        alertController = UIAlertController(title: "Saved", message: "Your drawing has been successfully saved to the photo album", preferredStyle: UIAlertControllerStyle.Alert)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        
        alertController = UIAlertController(title: "Saved", message: "Your drawing has been successfully saved to the photo album", preferredStyle: UIAlertControllerStyle.Alert)
        
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Custom Draw"
        
        let dismissBarButton = UIBarButtonItem(title: "Dismiss", style: UIBarButtonItemStyle.Done, target: self, action: "dismissButtonPressed")
        self.navigationItem.leftBarButtonItem = dismissBarButton
        
        let sendBarButton = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Done, target: self, action: "sendButtonPressed")
        self.navigationItem.rightBarButtonItem = sendBarButton
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        // Setup Brush Palette controller
        let brushPaletteController = FVBrushPaletteViewController(nibName: "FVBrushPaletteViewController", bundle: nil)
        brushPaletteController.delegate = self
        
        brushPaletteController.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.size.height - 95, width: self.view.frame.size.width, height: 191)
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
        
        tempImageView.image = nil
    }
    
    
    
    func drawPoint(pt: CGPoint, inRect rect: CGRect) {
        
        if self.brushType == FVBrushTypes.round {
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            
            let ellipseRect = CGRect(x: pt.x - brushDiameter/2, y: pt.y - brushDiameter/2, width: brushDiameter, height: brushDiameter)
            
            CGContextSetFillColorWithColor(context, brushColor)
            CGContextFillEllipseInRect(context, ellipseRect)
            
            tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        } else if self.brushType == FVBrushTypes.square {
            self.drawRectangularPoint(pt, verticalSqueezeFactor: 1, inRect: rect)
        } else if self.brushType == FVBrushTypes.rectangularFlat {
            self.drawRectangularPoint(pt, verticalSqueezeFactor: 2, inRect: rect)
        } else if self.brushType == FVBrushTypes.rectangularThin {
            self.drawRectangularPoint(pt, verticalSqueezeFactor: 0.5, inRect: rect)
        }
        
    }
    
    
    func drawRectangularPoint(pt: CGPoint, verticalSqueezeFactor: CGFloat, inRect rect: CGRect) {
        
        let zoomedBushWidth = brushDiameter * verticalSqueezeFactor
        let zoomedBushHeight = brushDiameter / verticalSqueezeFactor
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        let brushRect = CGRect(x: pt.x - zoomedBushWidth/2, y: pt.y - zoomedBushHeight/2, width: zoomedBushWidth, height: zoomedBushHeight)
        
        CGContextSetFillColorWithColor(context, brushColor)
        CGContextFillRect(context, brushRect)
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    func drawLine(pt1: CGPoint, pt2: CGPoint, inRect rect: CGRect) {
        if self.brushType == FVBrushTypes.round {
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
            
        } else if self.brushType == FVBrushTypes.square {
            self.drawRectangularLine(pt1, pt2: pt2, verticalSqueezeFactor: 1, inRect: rect)
        } else if self.brushType == FVBrushTypes.rectangularFlat {
            self.drawRectangularLine(pt1, pt2: pt2, verticalSqueezeFactor: 2, inRect: rect)
        } else if self.brushType == FVBrushTypes.rectangularThin {
            self.drawRectangularLine(pt1, pt2: pt2, verticalSqueezeFactor: 0.5, inRect: rect)
        }

    }
    

    func drawRectangularLine(pt1: CGPoint, pt2: CGPoint, verticalSqueezeFactor: CGFloat, inRect rect: CGRect) {
        UIGraphicsBeginImageContext(rect.size)
        tempImageView.image?.drawInRect(tempImageView.bounds, blendMode: CGBlendMode.Normal, alpha: 1.0)
        
        let path = UIBezierPath()
        let pathColor = UIColor(CGColor: self.brushColor)
        pathColor.setFill()
        
        let brushWidth = brushDiameter * verticalSqueezeFactor
        let brushHeight = brushDiameter / verticalSqueezeFactor
        
        let xHalf = brushWidth / 2.0
        let yHalf = brushHeight / 2.0
        
        // Convenience Variables
        
        // pt1 rectangle's lower left corner point
        let pointA = CGPoint(x: pt1.x - xHalf, y: pt1.y + yHalf)
        // upper left
        let pointB = CGPoint(x: pointA.x, y: pointA.y - brushHeight)
        // upper right
        let pointC = CGPoint(x: pt1.x + xHalf, y: pt1.y - yHalf)
        // lower right
        let pointX = CGPoint(x: pt1.x + xHalf, y: pt1.y + yHalf)
        
        // ***************************************************
        // pt2 rectangle's upper right corner point
        let pointD = CGPoint(x: pt2.x + xHalf, y: pt2.y - yHalf)
        // lower right
        let pointE = CGPoint(x: pointD.x, y: pointD.y + brushHeight)
        // lower left
        let pointF = CGPoint(x: pt2.x - xHalf, y: pt2.y + yHalf)
        // upper left
        let pointY = CGPoint(x: pt2.x - xHalf, y: pt2.y - yHalf)
        
        // Helpful to draw a diamond shaped path to visualize
        if (pt1.x < pt2.x) {
            
            if (pt1.y < pt2.y) { // pt1 is upper left than pt2
                path.moveToPoint(pointA)
                path.addLineToPoint(pointB)
                path.addLineToPoint(pointC)
                
                path.addLineToPoint(pointD)
                path.addLineToPoint(pointE)
                path.addLineToPoint(pointF)
                
            } else { // pt1 is lower left than pt2
                path.moveToPoint(pointB)
                path.addLineToPoint(pointA)
                path.addLineToPoint(pointX)
                
                path.addLineToPoint(pointE)
                path.addLineToPoint(pointD)
                path.addLineToPoint(pointY)
            }
            
        } else {
            if (pt1.y < pt2.y) { // pt1 is upper right than pt2
                path.moveToPoint(pointB)
                path.addLineToPoint(pointC)
                path.addLineToPoint(pointX)
                
                path.addLineToPoint(pointE)
                path.addLineToPoint(pointF)
                path.addLineToPoint(pointY)
            } else { // pt1 is lower right than pt2
                path.moveToPoint(pointA)
                path.addLineToPoint(pointX)
                path.addLineToPoint(pointC)
                
                path.addLineToPoint(pointD)
                path.addLineToPoint(pointY)
                path.addLineToPoint(pointF)
            }
        }
        
        path.closePath()
        path.fillWithBlendMode(CGBlendMode.Normal, alpha: 1.0)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.image = image
        
        UIGraphicsEndImageContext()
    }
    
    
    // MARK: FVBrushPaletteProtocolForCanvas
    
    func brushPalette(palette: FVBrushPaletteViewController, changeBrushSizeTo brushDiameter: CGFloat) {
        self.brushDiameter = brushDiameter
    }
    
    func brushPalette(palette: FVBrushPaletteViewController, changeBrushColorTo brushColor: CGColorRef) {
        self.brushColor = brushColor
    }
    
    func brushPalette(palette: FVBrushPaletteViewController, changeBrushTypeTo brushType: FVBrushTypes) {
        
        self.brushType = brushType
    }
    
    func brushPaletteUndoCanvas(palette: FVBrushPaletteViewController) {
       
    }
    
    func brushPaletteRedoCanvas(palette: FVBrushPaletteViewController) {
        
    }
    
    func brushPaletteClearCanvas(palette: FVBrushPaletteViewController) {
        
        self.tempImageView.image = nil
        self.mainImageView.image = nil
    }
    
    
    func brushPaletteSaveCanvas(palette: FVBrushPaletteViewController) {
        if (mainImageView.image == nil) {
            return
        }
        
        // Add black background before saving
        UIGraphicsBeginImageContext(self.mainImageView.frame.size)
        let path = UIBezierPath(rect: self.mainImageView.bounds)
        UIColor.blackColor().setFill()
        path.fill()
        
        self.mainImageView.image?.drawInRect(self.mainImageView.bounds)
        
        let imageWithBlackBackground = UIGraphicsGetImageFromCurrentImageContext()
        mainImageView.image = imageWithBlackBackground
        
        UIImageWriteToSavedPhotosAlbum(mainImageView.image!,nil,nil,nil)
        
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "dismissAlert", userInfo: nil, repeats: false)
        self.presentViewController(self.alertController, animated: true, completion: nil)
    }
    
    // MARK: Dismiss Alert
    func dismissAlert() {
        self.alertController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
