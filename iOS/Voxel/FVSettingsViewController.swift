//
//  FVSettingsViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 12/25/15.
//  Copyright © 2015 Si Te Feng. All rights reserved.
//

import UIKit

class FVSettingsViewController: HNAbstractViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let kSettingsTableViewCellIdentifier = "kSettingsTableViewCellIdentifier"
    let kGeneralTableViewCellIdentifier = "kGeneralTableViewCellIdentifier"
    let kSettingsTableViewHeaderIdentifier = "kSettingsTableViewHeaderIdentifier"
    
    let sectionTitles = ["Voxel Configuration", "Start Delay", "LED Frequency", "LED Brightness"]
    let configurationStrings = ["Paint Brush Mode (1)", "Paint Brush Mode (2L)","Paint Brush Mode (2R)","Paint Brush Mode (3)","Paint Brush Mode (4L)", "Paint Brush Mode (4R)", "Paint Brush Mode (5)", "Light Saber Mode (1)", "Light Saber Mode (2)", "Light Saber Mode (3)"]
    
    let sectionNumRows = [1, 1, 1, 1, 2]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
        
        self.tableView.registerNib(UINib(nibName: "FVSettingsTableViewCell", bundle: nil), forCellReuseIdentifier: kSettingsTableViewCellIdentifier)
        self.tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: kSettingsTableViewHeaderIdentifier)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kGeneralTableViewCellIdentifier)
        
        
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionNumRows[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tableCell: UITableViewCell!
        
        if indexPath.section == 0 {
            tableCell = self.tableView.dequeueReusableCellWithIdentifier(kGeneralTableViewCellIdentifier)
            
            var voxelConfig = FVConnectionManager.sharedManager().connectedVoxel?.configuration()
            if voxelConfig == nil {
                voxelConfig = .HorizontalOne
            }
            
            tableCell.textLabel?.text = "Voxel Type: " + configurationStrings[voxelConfig!.rawValue]
            tableCell.textLabel?.textColor = UIColor.whiteColor()
            
        } else {
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier(kSettingsTableViewCellIdentifier) as! FVSettingsTableViewCell
            
            cell.slider.value = self.retrieveValueFromUserDefaults(indexPath)
            cell.sideLabel.text = sideLabelForCell(indexPath, value: cell.slider.value)
            
            cell.indexPath = indexPath
            cell.settingsController = self
            tableCell = cell
        }
        
        tableCell.backgroundColor = UIColor.clearColor()
        
        return tableCell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.isEqual(NSIndexPath(forRow: 0, inSection: 0)) {
            let typeController = FVVoxelTypePopupViewController()
            
            self.showChildViewController(typeController)
        }
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(40)
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let nibViews = NSBundle.mainBundle().loadNibNamed("FVSettingsTableHeader", owner: self, options: nil)
        let headerView = nibViews.first as! FVSettingsTableHeader
        
        headerView.label.text = sectionTitles[section]
        
        return headerView
    }
    
    
    // Cell Callback
    func sliderValueChangedForTableCell(indexPath: NSIndexPath, newValue: Float) {
        let tableCell = tableView.cellForRowAtIndexPath(indexPath) as! FVSettingsTableViewCell
        
        let defaults = NSUserDefaults.standardUserDefaults();
        
        switch(indexPath.section) {
        case 1:
            defaults.setFloat(newValue, forKey: FVGlobal.kDefaultsVoxelDelayKey)
        case 2:
            defaults.setFloat(newValue, forKey: FVGlobal.kDefaultsVoxelFrequencyKey)
        case 3:
            defaults.setFloat(newValue, forKey: FVGlobal.kDefaultsVoxelBrightnessKey)
        default:
            assert(false)
            
        }
        
        tableCell.sideLabel.text = sideLabelForCell(indexPath, value: newValue)
    }
    
    func sideLabelForCell(indexPath: NSIndexPath, value: Float) -> String {
        if (indexPath.section == 1 ) {
            let delay = value * 20
            return String(format: "%.01f", delay)
            
        } else if (indexPath.section == 2) {
            let freq = 2 + value * 28
            return String(format: "%.0f", freq)
            
        } else if (indexPath.section == 3) {
            let brightness = 2 + value * 100
            return String(format: "%.0f", brightness)
        } else {
            assert(false)
        }

    }
    
    func retrieveValueFromUserDefaults(indexPath: NSIndexPath) -> Float {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var value: Float = 0.0
        
        switch(indexPath.section) {
        case 1:
            value = defaults.floatForKey(FVGlobal.kDefaultsVoxelDelayKey)
        case 2:
            value = defaults.floatForKey(FVGlobal.kDefaultsVoxelFrequencyKey)
        case 3:
            value = defaults.floatForKey(FVGlobal.kDefaultsVoxelBrightnessKey)
        default:
            assert(false)
        }
        
        return value
    }
    
    // MARK: Other Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
