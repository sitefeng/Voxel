//
//  FVSetLEDsColorViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 1/9/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

class FVSetLEDsColorViewController: UIViewController {

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var trashButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colorView.layer.borderColor = UIColor.whiteColor().CGColor
        self.colorView.layer.borderWidth = 2
        self.colorView.layer.cornerRadius = 22
        self.colorView.layer.masksToBounds = true
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
