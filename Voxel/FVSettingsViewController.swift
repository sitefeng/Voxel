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
    
    let sectionTitles = ["Start Delay", "LED Frequency", "LED Brightness", "Sweep Direction"]
    
    let sectionNumRows = [1, 1, 1, 2]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
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
        
        if indexPath.section <= 2 ||
           indexPath.section >= 4 {
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier(kSettingsTableViewCellIdentifier) as! FVSettingsTableViewCell
            
            cell.sideLabel.text = ""
            
            tableCell = cell
            
        } else if indexPath.section == 3 {
            tableCell = self.tableView.dequeueReusableCellWithIdentifier(kGeneralTableViewCellIdentifier)
        }
        
        return tableCell
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(40)
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier(kSettingsTableViewHeaderIdentifier) as! FVSettingsTableHeader
        
        header.label.text = sectionTitles[section]
        
        return header
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
