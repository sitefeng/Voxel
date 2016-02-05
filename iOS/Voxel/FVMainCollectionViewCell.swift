//
//  FVMainCollectionViewCell.swift
//  Voxel
//
//  Created by Si Te Feng on 12/25/15.
//  Copyright © 2015 Si Te Feng. All rights reserved.
//

import UIKit

class FVMainCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.layer.cornerRadius = CGFloat(HNGlobal.mainCornerRadius)
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(colorType: HNColorTypes.WhiteTransluscent)
    }

}
