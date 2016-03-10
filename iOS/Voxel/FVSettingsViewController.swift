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
            tableCell.textLabel?.text = "Voxel Type"
            tableCell.textLabel?.textColor = UIColor.whiteColor()
            
        } else {
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier(kSettingsTableViewCellIdentifier) as! FVSettingsTableViewCell
            cell.sideLabel.text = ""
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
        if (indexPath.section == 1 ) {
            let delay = newValue * 20
            tableCell.sideLabel.text = String(format: "%.01f", delay)
            
            defaults.setFloat(delay, forKey: FVGlobal.kDefaultsVoxelDelayKey)
            
        } else if (indexPath.section == 2) {
            let freq = 2 + newValue * 28
            tableCell.sideLabel.text = String(format: "%.0f", freq)
            defaults.setFloat(freq, forKey: FVGlobal.kDefaultsVoxelFrequencyKey)
            
        } else if (indexPath.section == 3) {
            let brightness = 2 + newValue * 100
            tableCell.sideLabel.text = String(format: "%.0f%", brightness)
            defaults.setFloat(brightness, forKey: FVGlobal.kDefaultsVoxelBrightnessKey)
        }
        
    }
    
    
    // MARK: Other Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
