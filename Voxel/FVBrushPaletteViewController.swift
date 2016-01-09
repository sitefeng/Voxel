//
//  FVBrushPaletteViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 1/4/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

protocol FVBrushPaletteProtocolForCanvas {
    
    func brushPalette(palette: FVBrushPaletteViewController, changeBrushSizeTo brushDiameter: CGFloat)
    
    func brushPalette(palette: FVBrushPaletteViewController, changeBrushColorTo brushColor: CGColorRef)
    
    func brushPalette(palette: FVBrushPaletteViewController, changeBrushTypeTo brushType: FVBrushTypes)
    
    func brushPaletteUndoCanvas(palette: FVBrushPaletteViewController)
    func brushPaletteRedoCanvas(palette: FVBrushPaletteViewController)
    func brushPaletteClearCanvas(palette: FVBrushPaletteViewController)
    func brushPaletteSaveCanvas(palette: FVBrushPaletteViewController)
}


// Enum
public enum FVBrushTypes: Int {
    case round, square, rectangularFlat, rectangularThin
}

class FVBrushPaletteViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var dragBarView: UIView!
    
    @IBOutlet weak var sizeSlider: UISlider!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var checkerBoardView: UIImageView!
    @IBOutlet weak var brushPreview: UIImageView!
    
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var zoomFactorLabel: UILabel!

    // Constants
    let paletteFullHeight = CGFloat(191)
    let paletteRetractHeight = CGFloat(95)
    
    let maxBrushDiameter = CGFloat(40)
    let minBrushDiameter = CGFloat(3)
    
    let previewZoomFactor = CGFloat(1.3)
    
    // Public Variables
    var delegate: FVBrushPaletteProtocolForCanvas?
    
    var redComp = CGFloat(1)
    var greenComp = CGFloat(1)
    var blueComp = CGFloat(1)
    let alphaComp = CGFloat(1)
    
    var brushColor: CGColorRef {
        get {
            return UIColor(red: redComp, green: greenComp, blue: blueComp, alpha: alphaComp).CGColor
        }
    }
    var brushDiameter = CGFloat(8)
    
    var brushType = FVBrushTypes.round
    
    
    // Private Variables
    var retractedYPos = CGFloat(0)
    var expandedYPos: CGFloat {
        get {
            return retractedYPos - (paletteFullHeight - paletteRetractHeight)
        }
    }
    var beginYPos = CGFloat(0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO ReMOVE
        self.undoButton.hidden = true
        self.redoButton.hidden = true
        
        self.dragBarView.backgroundColor = UIColor(colorType: HNColorTypes.SecondaryBGColor)
        dragBarView.layer.cornerRadius = CGFloat(2.5)
        dragBarView.layer.masksToBounds = true
        
        self.checkerBoardView.layer.borderColor = brushColor
        self.checkerBoardView.layer.borderWidth = 2
        self.checkerBoardView.layer.cornerRadius = 5
        self.checkerBoardView.layer.masksToBounds = true
        
        self.zoomFactorLabel.text = "\(previewZoomFactor)x"
        
        // Adding Gesture Recognizers
        let panRec = UIPanGestureRecognizer(target: self, action: "panRecognized:")
        panRec.delegate = self
        self.view.addGestureRecognizer(panRec)
        
        let tapRec = UITapGestureRecognizer(target: self, action: "brushPreviewTapped:")
        tapRec.delegate = self
        self.brushPreview.addGestureRecognizer(tapRec)
        
        
        // Adding targets of UI Elements
        sizeSlider.addTarget(self, action: "sliderChanged:", forControlEvents: UIControlEvents.ValueChanged)
        redSlider.addTarget(self, action: "sliderChanged:", forControlEvents: UIControlEvents.ValueChanged)
        greenSlider.addTarget(self, action: "sliderChanged:", forControlEvents: UIControlEvents.ValueChanged)
        blueSlider.addTarget(self, action: "sliderChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        undoButton.addTarget(self, action: "undoButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        redoButton.addTarget(self, action: "redoButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        trashButton.addTarget(self, action: "trashButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        saveButton.addTarget(self, action: "saveButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        // Reset all UI elements
        sizeSlider.value = Float((brushDiameter - minBrushDiameter)/(maxBrushDiameter - minBrushDiameter))
        redSlider.value = Float(redComp)
        greenSlider.value = Float(greenComp)
        blueSlider.value = Float(blueComp)
        
        // Show Preview of the Brush
        self.drawRoundBrush()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        retractedYPos = self.view.frame.origin.y
    }
    
    
    // MARK: Sliders
    func sliderChanged(slider: UISlider) {
        if (slider == sizeSlider) {
            
            let normalizedDiameter = minBrushDiameter + CGFloat(slider.value) * (maxBrushDiameter - minBrushDiameter)
            
            brushDiameter = normalizedDiameter
            self.delegate?.brushPalette(self, changeBrushSizeTo: brushDiameter)
            
        } else if slider == redSlider {
            redComp = CGFloat(slider.value)
            self.delegate?.brushPalette(self, changeBrushColorTo: brushColor)
            
        } else if slider == greenSlider {
            greenComp = CGFloat(slider.value)
            self.delegate?.brushPalette(self, changeBrushColorTo: brushColor)
        } else if slider == blueSlider {
            blueComp = CGFloat(slider.value)
            self.delegate?.brushPalette(self, changeBrushColorTo: brushColor)
        }
        
        rerenderPreview()
        
    }
    
    // MARK: Button Callbacks
    
    func undoButtonPressed() {
        self.delegate?.brushPaletteUndoCanvas(self)
    }
    
    func redoButtonPressed() {
        self.delegate?.brushPaletteRedoCanvas(self)
    }
    
    func trashButtonPressed() {
        self.delegate?.brushPaletteClearCanvas(self)
    }
    
    func saveButtonPressed() {
        self.delegate?.brushPaletteSaveCanvas(self)
    }
    
    
    func brushPreviewTapped(rec: UITapGestureRecognizer) {
        
        if rec.state == UIGestureRecognizerState.Ended {
            
            if brushType.rawValue == FVBrushTypes.rectangularThin.rawValue {
                brushType = FVBrushTypes.round
            } else {
                brushType = FVBrushTypes(rawValue: brushType.rawValue + 1)!
            }
            
            self.delegate?.brushPalette(self, changeBrushTypeTo: brushType)
            self.rerenderPreview()
        }
    }
    
    
    func panRecognized(rec: UIPanGestureRecognizer) {
        
        if rec.state == UIGestureRecognizerState.Began {
            self.dragBarView.backgroundColor = UIColor(colorType: HNColorTypes.OrangeActionColor)
            beginYPos = self.view.frame.origin.y
            
        } else if rec.state == UIGestureRecognizerState.Changed {
            
            let viewFrame = self.view.frame
            let translation = rec.translationInView(self.view).y
            
            let currYPos = beginYPos + translation
            self.view.frame = CGRect(x: viewFrame.origin.x, y: currYPos, width: viewFrame.size.width, height: viewFrame.size.height)
            
        } else if rec.state == UIGestureRecognizerState.Ended {
            self.dragBarView.backgroundColor = UIColor(colorType: HNColorTypes.SecondaryBGColor)
            
            let currYPos = self.view.frame.origin.y
            let expandYPosThreshold = retractedYPos - 48
            
            if currYPos < expandYPosThreshold {
                
                expandPalette()
                
            } else { // currYPos > expandYPosThreshold
                retractPalette()
            }
            
        }
        
    }
    
    
    func expandPalette() {
        let viewFrame = self.view.frame
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.view.frame = CGRect(x: viewFrame.origin.x, y: self.expandedYPos, width: viewFrame.size.width, height: viewFrame.size.height)
            
            }, completion: nil)
        
    }
    

    func retractPalette() {
        let viewFrame = self.view.frame
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.view.frame = CGRect(x: viewFrame.origin.x, y: self.retractedYPos
                , width: viewFrame.size.width, height: viewFrame.size.height)
            
            }, completion: nil)
    }
    
    
    // MARK: Drawing Methods
    
    func rerenderPreview() {
        
        // Change Preview box border color
        checkerBoardView.layer.borderColor = brushColor
        
        // Brush Preview
        switch brushType {
            case .round:
                drawRoundBrush()
            case .square:
                drawRectangularBrush(1)
            case .rectangularFlat:
                drawRectangularBrush(2)
            case .rectangularThin:
                drawRectangularBrush(0.5)
          
        }
        
    }
    
    
    func drawRoundBrush() {
        
        let zoomedBushDiameter = brushDiameter * previewZoomFactor
        
        let rect = brushPreview.frame
        let pt = CGPoint(x: brushPreview.frame.size.width/2, y: brushPreview.frame.size.height/2)
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        let ellipseRect = CGRect(x: pt.x - zoomedBushDiameter/2, y: pt.y - zoomedBushDiameter/2, width: zoomedBushDiameter, height: zoomedBushDiameter)
        
        CGContextSetFillColorWithColor(context, brushColor)
        CGContextFillEllipseInRect(context, ellipseRect)
        
        brushPreview.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    func drawRectangularBrush(verticalSqueezeFactor: CGFloat) {
        
        let zoomedBushWidth = brushDiameter * previewZoomFactor * verticalSqueezeFactor
        let zoomedBushHeight = brushDiameter * previewZoomFactor / verticalSqueezeFactor
        
        let rect = brushPreview.frame
        let pt = CGPoint(x: brushPreview.frame.size.width/2, y: brushPreview.frame.size.height/2)
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        let brushRect = CGRect(x: pt.x - zoomedBushWidth/2, y: pt.y - zoomedBushHeight/2, width: zoomedBushWidth, height: zoomedBushHeight)
        
        CGContextSetFillColorWithColor(context, brushColor)
        CGContextFillRect(context, brushRect)
        
        brushPreview.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKindOfClass(UITapGestureRecognizer.self) ||
            otherGestureRecognizer.isKindOfClass(UITapGestureRecognizer.self) {
                return true
        } else {
            return false
        }
    }
    
    
    
}
