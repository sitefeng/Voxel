//
//  FVVoxel.swift
//  Voxel
//
//  Created by Si Te Feng on 1/17/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

public enum FVVoxelConfigurations: Int {
    
    case Unconfigured
    
    // Horizontal Configurations
    case HorizontalOne
    case HorizontalLeftTwo, HorizontalRightTwo
    case HorizontalThree
    case HorizontalLeftFour, HorizontalRightFour
    case HorizontalFive
    
    // Vertical Configurations
    case VerticalOne
    case VerticalTwo
    case VerticalThree
}


class FVVoxel: NSObject {
    
    let numLEDsPerModule = 57

    private(set) var configuration: FVVoxelConfigurations
    
    private(set) var serialNumber: String
    private(set) var name: String
    
    private(set) var firmwareVersion: Float // 1.0
    private(set) var connected: Bool
    
    
    override init() {
//        self.configuration = .Unconfigured
//        self.serialNumber = ""
//        self.name = ""
//        self.firmwareVersion = 0
//        self.connected = false
        
        // TODO: Creating a fake voxel upon initialization
        self.configuration = .HorizontalFive
        self.serialNumber = "H4Y7D2"
        self.name = "Voxel-H4Y7"
        self.firmwareVersion = 1.0
        self.connected = true
    
        super.init()
    }
    
    func numLEDs() -> Int {
        return numLEDsPerModule * numModules()
    }
    
    func numModules() -> Int {
        var modules = 0
        switch(self.configuration) {
            case .HorizontalOne, .VerticalOne:
                modules = 1
            case .HorizontalLeftTwo, .HorizontalRightTwo, .VerticalTwo:
                modules = 2
            case .HorizontalThree, .VerticalThree:
                modules = 3
            case .HorizontalLeftFour, .HorizontalRightFour:
                modules = 4
            case .HorizontalFive:
                modules = 5
            default:
                modules = 0
        }
        return modules
    }
    
    
    func getBatteryLevel(completion: (Float)->Void) {
        
        // TODO
        let batteryLevel: Float = 0.6
        completion(batteryLevel)
    }
    
    
}
