//
//  FVWirelessImageMessage.swift
//  Voxel
//
//  Created by Si Te Feng on 1/17/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

class FVWirelessImageMessage: FVWirelessMessage {
    
    var data: NSData
    var imageSize: CGSize
    
    override init() {
        data = NSData()
        imageSize = CGSize()
        super.init()
    }
    
    convenience init(image: UIImage) {
        self.init()
        messageType = FVWirelessMessageType.Image
        
        guard let currVoxel = FVConnectionManager.sharedManager().connectedVoxel else {
            print("No Connected Voxels")
            return
        }
        
        let numLEDs = CGFloat(currVoxel.numLEDs())
        let scaleFactor = numLEDs / image.size.height
        imageSize = CGSize(width: image.size.width * scaleFactor, height: image.size.height * scaleFactor)
        
        let resizedImage = FVUtility.imageWithImage(image, scaledToSize: imageSize)
        
        if let dataOrNil = UIImageJPEGRepresentation(resizedImage, 0.3) {
            data = dataOrNil
            
        }
    }
    
    override func transmitDictionary() -> [String: String] {
        let base64Data = data.base64EncodedDataWithOptions([])
        let imgString = String(data: base64Data, encoding: NSUTF8StringEncoding)!
        
        var dict = [String: String]()
        
        dict["width"] = "\(imageSize.width)"
        dict["height"] = "\(imageSize.height)"
        dict["data"] = imgString
        
        
        
        return dict
    }
    
    
}
