//
//  FVWirelessMessage.swift
//  Voxel
//
//  Created by Si Te Feng on 1/17/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

public enum FVWirelessMessageType: Int {
    case None = 0
    case ChangeSettings
    case SetLEDs
    case Image
    
}


// ABSTRACT class
class FVWirelessMessage: NSObject {
    
    internal var messageType: FVWirelessMessageType
    
    override init() {
        messageType = .None
        super.init()
    }
    
    
    func transmitDictionary() -> [String: String] {
        assertionFailure("Message transmit function Not Implemented by Child")
        return [String: String]()
    }
    
}
