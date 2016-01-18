//
//  FVSetLEDsColorViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 1/9/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

protocol FVSetLEDsColorViewControllerDelegate {
    func clearActiveLEDModule()
    func setLEDsColorViewController(controller: FVSetLEDsColorViewController, colorChanged newColor: UIColor)
}

class FVSetLEDsColorViewController: UIViewController {

    var delegate: FVSetLEDsColorViewControllerDelegate?
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var trashButton: UIButton!
    
    // Internal Variables
    var currentColor: UIColor = UIColor.whiteColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colorView.layer.borderColor = UIColor.whiteColor().CGColor
        self.colorView.layer.borderWidth = 2
        self.colorView.layer.cornerRadius = 22
        self.colorView.layer.masksToBounds = true
        
        self.redSlider.addTarget(self, action: "colorChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.greenSlider.addTarget(self, action: "colorChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.blueSlider.addTarget(self, action: "colorChanged:", forControlEvents: UIControlEvents.ValueChanged)
    
        // Initialize values
        self.redSlider.value = 1
        self.greenSlider.value = 1
        self.blueSlider.value = 1
        
        self.colorView.backgroundColor = self.currentColor
    }

    
    func colorChanged(slider: UISlider) {
        let red = self.redSlider.value
        let green = self.greenSlider.value
        let blue = self.blueSlider.value
        
        self.currentColor = UIColor(colorLiteralRed: red, green: green, blue: blue, alpha: 1)
        
        self.colorView.backgroundColor = self.currentColor
        self.delegate?.setLEDsColorViewController(self, colorChanged: self.currentColor)
    }
    
    
    @IBAction func trashButtonPressed(sender: AnyObject) {
        self.delegate?.clearActiveLEDModule()
        
    }
    
    
   
}
