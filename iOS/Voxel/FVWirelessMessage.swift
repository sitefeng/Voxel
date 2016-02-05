//
//  FVWirelessMessage.swift
//  Voxel
//
//  Created by Si Te Feng on 1/17/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

public enum FVWirelessMessageType: Int {
    case Connection = 0x01
    case ChangeSettings = 0x02
    case Image = 0x03
    case ImageSeries = 0x04
}

// ABSTRACT class
class FVWirelessMessage: NSObject {
    
    private var messageType: FVWirelessMessageType
    
    override init() {
        messageType = .Connection
        super.init()
    }
    
}
