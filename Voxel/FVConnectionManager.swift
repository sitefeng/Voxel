//
//  FVConnectionManager.swift
//  Voxel
//
//  Created by Si Te Feng on 1/17/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

public enum FVConnectionStatus: Int {
    case Disconnected
    case Connecting
    case Connected
}

let sharedConnectionManager = FVConnectionManager()

class FVConnectionManager: NSObject {
    
    class func sharedManager() -> FVConnectionManager {
        return sharedConnectionManager
    }
    
    var connectedVoxel: FVVoxel?
    var connectionStatus: FVConnectionStatus = .Disconnected
    
    override init() {
        
        // TODO: Connecting to a fake voxel upon creation
        let voxel = FVVoxel()
        connectedVoxel = voxel
        connectionStatus = FVConnectionStatus.Connected
        super.init()
    }
    
    func exploreNearbyVoxels(completion: ([FVVoxel])->Void) {
        let voxels: [FVVoxel] = []
        completion(voxels)
    }
    
    
    // Completion returns true if conection is successful
    func connectToVoxel(inout voxel: FVVoxel, completion: (success: Bool)-> Void) {
        
        completion(success: false)
    }
    
    
    func sendMessageToVoxel(message: FVWirelessMessage, completion: (response: FVWirelessMessageResponse)->Void) {
        
        let response = FVWirelessMessageResponse(rawData: NSData())
        completion(response: response)
    }
    
    
    func disconnectVoxel() {
        
    }
    
    
}
