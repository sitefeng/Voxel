//
//  FVSetLEDsViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 1/9/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

class FVSetLEDsViewController: FVPatternAbstractViewController {

    @IBOutlet weak var voxelPreview: UIView!
    @IBOutlet weak var setLEDsModuleView: UIView!
    @IBOutlet weak var setLEDsColorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Custom Draw"
        
        // Setup Child View Controllers
        let voxelPreviewVC = FVVoxelPreviewViewController(nibName: "FVVoxelPreviewViewController", bundle: nil)
        self.addChildViewController(voxelPreviewVC)
        voxelPreviewVC.view.frame = self.voxelPreview.bounds
        voxelPreviewVC.willMoveToParentViewController(self)
        self.voxelPreview.addSubview(voxelPreviewVC.view)
        
        let setLEDsModuleVC = FVSetLEDsModuleViewController(nibName: "FVSetLEDsModuleViewController", bundle: nil)
        self.addChildViewController(setLEDsModuleVC)
        setLEDsModuleVC.view.frame = self.setLEDsModuleView.bounds
        setLEDsModuleVC.willMoveToParentViewController(self)
        self.setLEDsModuleView.addSubview(setLEDsModuleVC.view)
        
        let setLEDsColorVC = FVSetLEDsColorViewController(nibName: "FVSetLEDsColorViewController", bundle: NSBundle.mainBundle())
        self.addChildViewController(setLEDsColorVC)
        setLEDsColorVC.view.frame = self.setLEDsColorView.bounds
        setLEDsColorVC.willMoveToParentViewController(self)
        self.setLEDsColorView.addSubview(setLEDsColorVC.view)
        
    }

    
    
    
    

}
