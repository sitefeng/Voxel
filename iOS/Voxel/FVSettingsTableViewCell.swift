//
//  FVSettingsTableViewCell.swift
//  Voxel
//
//  Created by Si Te Feng on 12/30/15.
//  Copyright © 2015 Si Te Feng. All rights reserved.
//

import UIKit

class FVSettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sideLabel: UILabel!
    
    var indexPath: NSIndexPath?
    weak var settingsController: FVSettingsViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.slider.addTarget(self, action: "sliderValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }


    func sliderValueChanged(sender: UISlider) {
        
        let value = sender.value
        print("sliderValue: \(value)")
        
        if (indexPath != nil && settingsController != nil) {
            settingsController!.sliderValueChangedForTableCell(indexPath!, newValue: value)
        }

    }
    
}
