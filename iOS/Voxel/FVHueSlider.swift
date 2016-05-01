//
//  FVHueSlider.swift
//  Voxel
//
//  Created by Si Te Feng on 3/31/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

class FVHueSlider: UIControl {

    var target: AnyObject?
    var action: Selector?
    
    var selectedHue: UIColor = UIColor.redColor()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func colorChanged() {
        
        
        for target in self.allTargets() {
            let actionsOrNil = self.actionsForTarget(target, forControlEvent: UIControlEvents.ValueChanged)
            guard let actions = actionsOrNil else {
                continue
            }
            
            for action in actions {
                
                self.sendAction(Selector(action), to: target, forEvent: nil)
            }
            
        }
        
        
    }
    
    

}
