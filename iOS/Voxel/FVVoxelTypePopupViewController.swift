//
//  FVVoxelTypePopupViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 3/9/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

class FVVoxelTypePopupViewController: HNAbstractViewController, UITableViewDataSource, UITableViewDelegate, FVVoxelPreviewViewControllerDelegate {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popupView: UIView!
    
    var previewController: FVVoxelPreviewViewController!
    @IBOutlet weak var voxelPreview: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let kVoxelTypeCellReuseIdentifier = "kVoxelTypeCellReuseIdentifier"
    let tableCellTitles = [
        ["One Module", "Two Modules", "Three Modules"],
        ["One Module", "Two Modules on Left", "Two Modules on Right", "Three Modules", "Four Modules lean Left", "Four Modules lean Right", "Five Modules"]
    ]

    let tableSections = ["Light Saber Mode", "Paint Brush Mode"]
    
    var selectedCell = NSIndexPath(forRow: 6, inSection: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popupView.layer.cornerRadius = 6
        self.popupView.layer.masksToBounds = true
        
        // Adding Voxel Preview
        previewController = FVVoxelPreviewViewController()
        previewController.delegate = self
        previewController.showModuleSelectionBox = false
        self.addChildViewController(previewController)
        self.voxelPreview.addSubview(previewController.view)
        previewController.didMoveToParentViewController(self)
        
        self.tableView.registerNib(UINib(nibName: "FVVoxelTypeCell", bundle: nil), forCellReuseIdentifier: kVoxelTypeCellReuseIdentifier)
        
        retrieveAppConfiguration()
        
        let tapRec = UITapGestureRecognizer(target: self, action: "backgroundTapped")
        self.backgroundView.addGestureRecognizer(tapRec)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.previewController.view.frame = self.voxelPreview.bounds
        
    }
    
    
    // MARK: - Table View Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableSections.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCellTitles[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableCell = self.tableView.dequeueReusableCellWithIdentifier(kVoxelTypeCellReuseIdentifier) as! FVVoxelTypeCell
        
        if tableCell.titleLabel != nil {
            tableCell.titleLabel.text = tableCellTitles[indexPath.section][indexPath.row]
        }
        if tableCell.subtitleLabel != nil {
            tableCell.subtitleLabel.text = tableSections[indexPath.section]
        }
        
        if (indexPath.isEqual(self.selectedCell) && tableCell.checkImageView != nil) {
            tableCell.checkImageView.hidden = false
        } else {
            tableCell.checkImageView.hidden = true
        }
        
        return tableCell
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let prevCell = tableView.cellForRowAtIndexPath(selectedCell) as? FVVoxelTypeCell
        if prevCell != nil {
            prevCell!.customSelectCell(false)
        }
        
        selectedCell = indexPath
        updateAppConfiguration()
        self.previewController.resetView()
        
        let currCell = tableView.cellForRowAtIndexPath(selectedCell) as! FVVoxelTypeCell
        currCell.customSelectCell(true)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableSections[section]
    }
    
    // MARK: Button Callback
    @IBAction func checkButtonPressed(sender: AnyObject) {
        self.backgroundTapped()
    }
    
    
    // MARK: Preview Delegate
    
    func voxelPreviewController(controller: FVVoxelPreviewViewController, selectedModuleIndex: Int) {
        // Not required
    }
    
    
    // MARK: Gesture Recognizers callback
    func backgroundTapped() {
        let parentVC = self.parentViewController as! HNAbstractViewController
        parentVC.retractChildViewController(self)
    }
    
    
    
    // MARK: Update from/To Global Configs
    
    func retrieveAppConfiguration() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let voxelTypeRaw = defaults.integerForKey(FVGlobal.kDefaultsVoxelTypeKey)
        
        if voxelTypeRaw == 0 {
            defaults.setObject(FVVoxelConfigurations.HorizontalFive.rawValue, forKey: FVGlobal.kDefaultsVoxelTypeKey)
            return
        }
        
        switch(voxelTypeRaw) {
        case FVVoxelConfigurations.VerticalOne.rawValue:
            selectedCell = NSIndexPath(forRow: 0, inSection: 0)
        case FVVoxelConfigurations.VerticalTwo.rawValue:
            selectedCell = NSIndexPath(forRow: 1, inSection: 0)
        case FVVoxelConfigurations.VerticalThree.rawValue:
            selectedCell = NSIndexPath(forRow: 2, inSection: 0)
        case FVVoxelConfigurations.HorizontalOne.rawValue:
            selectedCell = NSIndexPath(forRow: 0, inSection: 1)
        case FVVoxelConfigurations.HorizontalLeftTwo.rawValue:
            selectedCell = NSIndexPath(forRow: 1, inSection: 1)
        case FVVoxelConfigurations.HorizontalRightTwo.rawValue:
            selectedCell = NSIndexPath(forRow: 2, inSection: 1)
        case FVVoxelConfigurations.HorizontalThree.rawValue:
            selectedCell = NSIndexPath(forRow: 3, inSection: 1)
        case FVVoxelConfigurations.HorizontalLeftFour.rawValue:
            selectedCell = NSIndexPath(forRow: 4, inSection: 1)
        case FVVoxelConfigurations.HorizontalRightFour.rawValue:
            selectedCell = NSIndexPath(forRow: 5, inSection: 1)
        case FVVoxelConfigurations.HorizontalFive.rawValue:
            selectedCell = NSIndexPath(forRow: 6, inSection: 1)
        default:
            selectedCell = NSIndexPath(forRow: 6, inSection: 1)
        }
    }
    
    
    func updateAppConfiguration() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var config = FVVoxelConfigurations.Unconfigured
        
        // Light Saber Mode
        if selectedCell.section == 0 {
            switch(selectedCell.row) {
            case 0:
                config = FVVoxelConfigurations.VerticalOne
            case 1:
                config = FVVoxelConfigurations.VerticalTwo
            case 2:
                config = FVVoxelConfigurations.VerticalThree
            default:
                config = .Unconfigured
            }
            
        } else if selectedCell.section == 1 { // Paint Brush Mode
            switch(selectedCell.row) {
            case 0:
                config = FVVoxelConfigurations.HorizontalOne
            case 1:
                config = FVVoxelConfigurations.HorizontalLeftTwo
            case 2:
                config = FVVoxelConfigurations.HorizontalRightTwo
            case 3:
                config = FVVoxelConfigurations.HorizontalThree
            case 4:
                config = FVVoxelConfigurations.HorizontalLeftFour
            case 5:
                config = FVVoxelConfigurations.HorizontalRightFour
            case 6:
                config = FVVoxelConfigurations.HorizontalFive
            default:
                config = .Unconfigured
            }
        }
        
        defaults.setObject(config.rawValue, forKey: FVGlobal.kDefaultsVoxelTypeKey)
        
    }
    
    
}





