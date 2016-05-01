//
//  FVVoxelPreviewViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 1/9/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit


protocol FVVoxelPreviewViewControllerDelegate {
    
    func voxelPreviewController(controller: FVVoxelPreviewViewController, selectedModuleIndex: Int)
    
}


class FVVoxelPreviewViewController: UIViewController {

    // Constants
    let margin = CGFloat(8)
    var maxHorizontalModules: Int {
        let modules = FVConnectionManager.sharedManager().connectedVoxel?.numModules()
        if modules == nil {
            return 0
        } else {
            return modules!
        }
    }
    
    @IBOutlet weak var horizontalPreview: UIImageView!
    @IBOutlet weak var verticalPreview: UIImageView!
    
    @IBOutlet weak var ledFrameView: UIImageView!
    @IBOutlet weak var ledImageView: UIImageView!
    var moduleSelectionView: UIImageView!
    
    // Public Var
    var moduleSelectionViewPosition: Int = 0
    var delegate: FVVoxelPreviewViewControllerDelegate?
    var showModuleSelectionBox = true
    var numLEDsPerModule = FVVoxel.numLEDsPerModule
    
    // Private Var
    var moduleColors: [[UIColor]] = []
    
    init?(_ coder: NSCoder? = nil) {
        
        self.moduleColors = []
        
        if let coder = coder {
            super.init(coder: coder)
        } else {
            super.init(nibName: nil, bundle:nil)
        }
        

    }
    
    required convenience init?(coder: NSCoder) {
        self.init(coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ledImageView.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(FVVoxelPreviewViewController.voxelTapped(_:)))
        ledImageView.addGestureRecognizer(tapRecognizer)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        resetView()
    }
    
    
    func resetView() {
        
        for _ in 0..<Int(self.maxHorizontalModules) {
            let colorArray = [UIColor]()
            self.moduleColors.append(colorArray)
        }
        
        let voxelOrNil = FVConnectionManager.sharedManager().connectedVoxel
        guard let voxel = voxelOrNil else {
            print("Voxel Type Not Selected!")
            return
        }
        
        // Setup module selection view
        self.setupModuleSelectionView(voxel)
        self.drawLEDFrame()
        
        // Fill in default black color
        var ledColors: [UIColor] = []
        
        for _ in 0 ..< numLEDsPerModule {
            ledColors.append(UIColor.blackColor())
        }
        
        for i in 0 ..< Int(maxHorizontalModules) {
            self.moduleColors[i] = ledColors
            self.moduleSelectionViewPosition = i
            self.drawLEDColors(ledColors, module: moduleSelectionViewPosition)
        }
        
        self.moduleSelectionViewPosition = 0
    }
    
    
    func setupModuleSelectionView(voxel: FVVoxel) {
        
        let totalWidth = UIScreen.mainScreen().bounds.size.width - margin*2
        let width = totalWidth / CGFloat(maxHorizontalModules)
        
        let imageView = UIImageView(image: UIImage(named: "borderLEDModuleSelection"))
        imageView.frame = CGRect(x: margin, y: margin, width: width, height: 35)
        imageView.alpha = 0.7
        self.view.addSubview(imageView)
        self.moduleSelectionView = imageView

        switch(voxel.configuration()) {
            
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
        
        // Hide if not needed
        self.moduleSelectionView.hidden = !showModuleSelectionBox
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
    
    
    // MARK: Public Methods
    func setLEDsColorsForCurrentModule(colors: [UIColor]) {
        self.setLEDColorsforModule(colors, module: moduleSelectionViewPosition)
    }
    
    func setLEDColorsforModule(colors: [UIColor], module: Int) {
        self.moduleColors[module] = colors
        self.drawLEDColors(colors, module: module)
    }
    
    
    func setSolidColorForAllModules(color: UIColor) {
        if self.moduleColors.count == 0 {
            return
        }
        
        for i in 0..<maxHorizontalModules {
            let colors = [UIColor](count: FVVoxel.numLEDsPerModule, repeatedValue: color)
            self.setLEDColorsforModule(colors, module: i)
        }
        
    }
    
    
    // MARK: Callback Methods
    func voxelTapped(rec: UITapGestureRecognizer) {
        
        let xPos = rec.locationInView(self.ledImageView).x
        let width = moduleSelectionView.frame.size.width
        let moduleIndex = Int( floor((xPos-margin) / width) )
        
        moveModuleSelectionViewToPosition(moduleIndex, animated: true)
        self.delegate?.voxelPreviewController(self, selectedModuleIndex: moduleIndex)
    }
    
    
    // MARK: Drawing Methods
    
    // Drawing the frame on top of led colors
    private func drawLEDFrame() {
        ledFrameView.image = nil
        
        let totalWidth = UIScreen.mainScreen().bounds.width - 2*margin
        let width = moduleSelectionView.frame.size.width
        let height = ledImageView.frame.size.height
        let xPos = CGFloat(0)
        
        UIGraphicsBeginImageContext(CGSize(width: totalWidth, height: ledImageView.bounds.height))
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
    
    
    private func drawLEDColors(array: [UIColor], module: Int) {
        
        let totalWidth = UIScreen.mainScreen().bounds.width - 2*margin
        let width = moduleSelectionView.frame.size.width
        let height = ledImageView.frame.size.height
        let xPos = CGFloat(module) * width
        
        UIGraphicsBeginImageContext(CGSize(width: totalWidth, height: ledImageView.bounds.height))
        self.ledImageView.image?.drawInRect(self.ledImageView.bounds)
        
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
    
    
    // For Sending to Hardware
    internal func combinedColorArray() -> [UIColor] {
        let colorArray = moduleColors.reduce([], combine: +)
        return colorArray
    }
    
    

}


