//
//  FVVoxelPreviewViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 1/9/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

class FVVoxelPreviewViewController: UIViewController {

    // Constants
    let margin = CGFloat(8)
    let maxHorizontalModules = CGFloat(5)
    
    @IBOutlet weak var horizontalPreview: UIImageView!
    @IBOutlet weak var verticalPreview: UIImageView!
    
    @IBOutlet weak var ledFrameView: UIImageView!
    @IBOutlet weak var ledImageView: UIImageView!
    var moduleSelectionView: UIImageView!
    
    var moduleSelectionViewPosition: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: "voxelTapped:")
        ledImageView.addGestureRecognizer(tapRecognizer)
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let voxelOrNil = FVConnectionManager.sharedManager().connectedVoxel
        guard let voxel = voxelOrNil else {
            print("Voxel Type Not Selected!")
            return
        }
        
        // Setup module selection view
        self.setupModuleSelectionView(voxel)
        
    }
    
    
    func setupModuleSelectionView(voxel: FVVoxel) {
        
        let totalWidth = self.ledImageView.bounds.size.width - margin*2
        let width = totalWidth / maxHorizontalModules
        
        let imageView = UIImageView(image: UIImage(named: "borderLEDModuleSelection"))
        imageView.frame = CGRect(x: margin, y: margin, width: width, height: 35)
        imageView.alpha = 0.5
        self.view.addSubview(imageView)
        self.moduleSelectionView = imageView

        switch(voxel.configuration) {
            
        case .HorizontalOne:
            moduleSelectionViewPosition = 2
        case .HorizontalLeftTwo:
            moduleSelectionViewPosition = 1
        case .HorizontalRightTwo:
            moduleSelectionViewPosition = 3
        case .HorizontalThree:
            moduleSelectionViewPosition = 1
        case .HorizontalLeftFour:
            moduleSelectionViewPosition = 0
        case .HorizontalRightFour:
            moduleSelectionViewPosition = 1
        case .HorizontalFive:
            moduleSelectionViewPosition = 0
        default:
            moduleSelectionViewPosition = 0
            
        }
        
        self.moveModuleSelectionViewToPosition(moduleSelectionViewPosition, animated: true)
        
    }
    
    
    func moveModuleSelectionViewToPosition(position: Int, animated: Bool) {
        moduleSelectionViewPosition = position
        
        let width = moduleSelectionView.frame.size.width
        
        var xPos: CGFloat = margin
        xPos += CGFloat(position) * width
        
        var animationDuration: NSTimeInterval = 0
        if animated {
            animationDuration = 0.5
        }
        
        UIView.animateWithDuration(animationDuration) { () -> Void in
            
            self.moduleSelectionView.frame = CGRect(x: xPos, y: self.moduleSelectionView.frame.origin.y, width: self.moduleSelectionView.frame.size.width, height: self.moduleSelectionView.frame.size.height)
        }
        
    }
    
    // MARK: Callback Methods
    func voxelTapped(rec: UITapGestureRecognizer) {
        
        let xPos = rec.locationInView(self.ledImageView).x
        let width = moduleSelectionView.frame.size.width
        let moduleIndex = Int( floor((xPos-margin) / width) )
        
        moveModuleSelectionViewToPosition(moduleIndex, animated: true)
    }
    
    
    // MARK: Drawing Methods
    
    // Drawing the frame on top of led colors
    func drawLEDFrame() {
        ledFrameView.image = nil
        
        let width = moduleSelectionView.frame.size.width
        let height = ledImageView.frame.size.height
        let xPos = CGFloat(0)
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: ledImageView.bounds.height))
        let context = UIGraphicsGetCurrentContext()
        
        let strokeColor = UIColor(colorType: HNColorTypes.SecondaryTextColor)
        CGContextSetStrokeColorWithColor(context, strokeColor?.CGColor)
        CGContextSetLineWidth(context, 1)
        
        for i in 0 ..< Int(maxHorizontalModules) {
            CGContextStrokeRect(context, CGRect(x: xPos + CGFloat(i) * width, y: 0, width: width, height: height))
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        ledFrameView.image = image
        
    }
    
    
    // Array of 57 pixels for the currently selected module
    func drawLEDColors(array: [UIColor]) {
        
        let width = moduleSelectionView.frame.size.width
        let height = ledImageView.frame.size.height
        let xPos = CGFloat(moduleSelectionViewPosition) * width
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: ledImageView.bounds.height))
        let context = UIGraphicsGetCurrentContext()
        
        let ledWidth = width / CGFloat(array.count)
        var ledxPos = xPos
        
        for color in array {
            
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextFillRect(context, CGRect(x: ledxPos, y: 0, width: ledWidth, height: height))
            ledxPos += ledWidth
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        ledImageView.image = image
    }
    
    
    

}


