//
//  FVSolidColorViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 1/9/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

class FVSolidColorViewController: FVPatternAbstractViewController {

    let preview: FVVoxelPreviewViewController? = FVVoxelPreviewViewController()
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Solid Color"
        
        guard let preview = preview else {
            print("preview does not exist")
            return
        }

        preview.showModuleSelectionBox = false
        preview.moduleSelectionViewPosition = 0
        
        redSlider.addTarget(self, action: #selector(colorChanged), forControlEvents: UIControlEvents.ValueChanged)
        greenSlider.addTarget(self, action: #selector(colorChanged), forControlEvents: UIControlEvents.ValueChanged)
        blueSlider.addTarget(self, action: #selector(colorChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        redSlider.value = 0
        greenSlider.value = 0
        blueSlider.value = 0
        self.colorChanged()
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let preview = preview else {
            print("preview view controller does not exist")
            return
        }
        
        preview.view.frame = self.topView.bounds
        
        self.addChildViewController(preview)
        self.topView.addSubview(preview.view)
        preview.didMoveToParentViewController(self)
        
    }
    
    
    func colorChanged() {
        let r = CGFloat(redSlider.value)
        let g = CGFloat(greenSlider.value)
        let b = CGFloat(blueSlider.value)
        
        let newColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        self.preview?.setSolidColorForAllModules(newColor)
    }
    
    
    
    
    
    
}
