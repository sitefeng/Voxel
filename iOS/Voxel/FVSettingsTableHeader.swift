//
//  FVSettingsTableHeader.swift
//  HackTheNorth
//
//  Created by Si Te Feng on 8/24/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit

class FVSettingsTableHeader: UIView {

    static let headerHeight: CGFloat = 39
    var shouldMakeAllCaps = true
    
    @IBOutlet weak var label: UILabel!
 
    func setText(text: String) {
        if self.shouldMakeAllCaps {
            label.text = text.uppercaseString
        } else {
            label.text = text
        }
    }
    

}
