//
//  FVNavigationController.swift
//  Voxel
//
//  Created by Si Te Feng on 1/4/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

class FVNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // set navigation bar tint color
        self.navigationBar.barTintColor = UIColor(colorType: HNColorTypes.NavigationBarColor)
        self.navigationBar.tintColor = UIColor.whiteColor()
        let font = UIFont(name: "Helvetica-Bold", size: 18)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName :UIColor.whiteColor(), NSFontAttributeName: font!]
    }

}
