//
//  FVVoxelTypeCell.swift
//  Voxel
//
//  Created by Si Te Feng on 3/9/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

class FVVoxelTypeCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.checkImageView.hidden = true
    }
    
    
    func customSelectCell(selected: Bool) {
    
        self.checkImageView.hidden = !selected
   
    }
    
    
    
}