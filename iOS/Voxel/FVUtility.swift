//
//  FVUtility.swift
//  Voxel
//
//  Created by Si Te Feng on 3/2/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

class FVUtility: NSObject {
    
    class func imageWithImage(image:UIImage, scaledToSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(scaledToSize, false, 0.0)
        image.drawInRect(CGRect(x: 0, y: 0, width: scaledToSize.width, height: scaledToSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

}
