//
//  FVSetLEDsViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 1/9/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

class FVSetLEDsViewController: UIViewController {

    @IBOutlet weak var voxelPreview: UIView!
    @IBOutlet weak var setLEDsModuleView: UIView!
    @IBOutlet weak var setLEDsColorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let voxelPreview = FVVoxelPreviewViewController(nibName: "FVVoxelPreviewViewController", bundle: NSBundle.mainBundle())
        
        self.addChildViewController(voxelPreview)
        voxelPreview.view.frame = self.voxelPreview.bounds
        voxelPreview.willMoveToParentViewController(self)
        
        
        
    }

    
    
    
    

}
