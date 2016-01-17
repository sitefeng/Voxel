//
//  FVWirelessMessageResponse.swift
//  Voxel
//
//  Created by Si Te Feng on 1/17/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

public enum FVWirelessMessageResponseTypes: Int {
    case Success
    case ConnectionTimeoutError
    case MessageStructureError // Syntax is wrong
    case MessageRequestError // Cannot satisfy request
    case VoxelError
    
}

class FVWirelessMessageResponse: NSObject {

    private var responseType: FVWirelessMessageResponseTypes
    
    override init() {
        self.responseType = .MessageStructureError
        super.init()
    }
    
    convenience init(rawData: NSData) {
        self.init()
        
        self.responseType = .MessageRequestError
        
    }
}
