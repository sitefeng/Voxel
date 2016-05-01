//
//  FVSetLEDsViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 1/9/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

class FVSetLEDsViewController: FVPatternAbstractViewController, FVVoxelPreviewViewControllerDelegate, FVSetLEDsModuleViewControllerDelegate, FVSetLEDsColorViewControllerDelegate {

    @IBOutlet weak var voxelPreview: UIView!
    @IBOutlet weak var setLEDsModuleView: UIView!
    @IBOutlet weak var setLEDsColorView: UIView!
    
    // Constants
    var numberOfModules = 0
    let numLEDsPerModule = FVVoxel.numLEDsPerModule
    
    // Public Variables
    private(set) var currSelectedModule = 0
    
    // private Variables
    private var voxelPreviewVC: FVVoxelPreviewViewController!
    private var ledModulesVCArray: [FVSetLEDsModuleViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Custom Draw"
        
        // Setup Child View Controllers
        self.voxelPreviewVC = FVVoxelPreviewViewController(nil)
        self.voxelPreviewVC.delegate = self
        self.addChildViewController(voxelPreviewVC)
        voxelPreviewVC.view.frame = self.voxelPreview.bounds
        voxelPreviewVC.willMoveToParentViewController(self)
        self.voxelPreview.addSubview(voxelPreviewVC.view)
        
        numberOfModules = FVConnectionManager.sharedManager().connectedVoxel!.numModules()
        
        // Setup LED Module Painting section
        for i in 1...numberOfModules {
            
            let setLEDsModuleVC = FVSetLEDsModuleViewController(nibName: "FVSetLEDsModuleViewController", bundle: nil)
            setLEDsModuleVC.delegate = self
            setLEDsModuleVC.labelTitle = "Module \(i)"
            setLEDsModuleVC.view.hidden = true
            self.addChildViewController(setLEDsModuleVC)
            setLEDsModuleVC.view.frame = self.setLEDsModuleView.bounds
            setLEDsModuleVC.willMoveToParentViewController(self)
            self.setLEDsModuleView.addSubview(setLEDsModuleVC.view)
            
            self.ledModulesVCArray.append(setLEDsModuleVC)
        }
        
        self.showSelectedLEDModuleAndHideOthers(currSelectedModule)
        
        
        let setLEDsColorVC = FVSetLEDsColorViewController(nibName: "FVSetLEDsColorViewController", bundle: NSBundle.mainBundle())
        setLEDsColorVC.delegate = self
        self.addChildViewController(setLEDsColorVC)
        setLEDsColorVC.view.frame = self.setLEDsColorView.bounds
        setLEDsColorVC.willMoveToParentViewController(self)
        self.setLEDsColorView.addSubview(setLEDsColorVC.view)
        
    }
    
    
    // MARK: Convenience Functions
    func showSelectedLEDModuleAndHideOthers(index: Int) {
        
        let oldSetLEDsModuleVC = self.ledModulesVCArray[currSelectedModule]
        oldSetLEDsModuleVC.view.hidden = true
        
        let newSetLEDsModuleVC = self.ledModulesVCArray[index]
        newSetLEDsModuleVC.view.hidden = false
        
        currSelectedModule = index
    }
    
    
    // MARK: FVVoxelPreviewViewControllerDelegate
    func voxelPreviewController(controller: FVVoxelPreviewViewController, selectedModuleIndex: Int) {
        
        self.showSelectedLEDModuleAndHideOthers(selectedModuleIndex)
        
    }
    
    
    func numberOfLEDsPerModule() -> Int {
        return self.numLEDsPerModule
    }
    
    // Set LEDs Color Delegate
    func clearActiveLEDModule() {
        let setLEDsModuleVC = self.ledModulesVCArray[currSelectedModule]
        setLEDsModuleVC.clearAllLEDs()
        
        var clearArray: [UIColor] = []
        for _ in 0 ..< numLEDsPerModule {
            clearArray.append(UIColor.blackColor())
        }
        
        self.voxelPreviewVC.setLEDsColorsForCurrentModule(clearArray)
        self.voxelPreviewVC.setLEDsColorsForCurrentModule(clearArray)
        self.voxelPreviewVC.setLEDsColorsForCurrentModule(clearArray)
    }
    
    
    func setLEDsColorViewController(controller: FVSetLEDsColorViewController, colorChanged newColor: UIColor) {
        
        for setLEDsModuleVC in self.ledModulesVCArray {
            setLEDsModuleVC.currBrushColor = newColor
        }
        
    }
    
    
    // MARK: Set LEDs Module Delegate
    func setLEDsModuleViewController(controller: FVSetLEDsModuleViewController, newColorArray: [UIColor]) {
        self.voxelPreviewVC.setLEDsColorsForCurrentModule(newColorArray)
        
    }

    
    // MARK: Send Data To Hardware
    override func sendButtonPressed() {
        let combinedArray = self.voxelPreviewVC.combinedColorArray()
        print(combinedArray)
        
    }
    
}
