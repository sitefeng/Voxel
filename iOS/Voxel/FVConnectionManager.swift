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

public enum FVWirelessMessageResponse: Int {
    case Success = 0
    case ConnectionError
    case MessageStructureError // Syntax is wrong
    case MessageRequestError // Cannot satisfy request
    
}

let sharedConnectionManager = FVConnectionManager()

class FVConnectionManager: NSObject {
    
    private let baseURL = "http://192.168.4.1/"
    
    var connectedVoxel: FVVoxel?
    var connectionStatus: FVConnectionStatus = .Disconnected
    
    class func sharedManager() -> FVConnectionManager {
        return sharedConnectionManager
    }
    
    override init() {
        
        // TODO: Connecting to a fake voxel upon creation
        let voxel = FVVoxel()
        connectedVoxel = voxel
        connectionStatus = FVConnectionStatus.Connected
        super.init()
    }
    

    
    func sendMessageToVoxel(message: FVWirelessMessage, completion: (response: FVWirelessMessageResponse)->Void) {
        
        var requestURLString = baseURL + "\(message.messageType.rawValue)/"
        requestURLString = requestURLString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        guard let url = NSURL(string: requestURLString) else {
            completion(response: .MessageStructureError)
            return
        }
        
        let dataDict = message.transmitDictionary()
        var data = NSData()
        do {
            data = try NSJSONSerialization.dataWithJSONObject(dataDict, options: [])
        } catch {
            print("JSON to data error")
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if (error != nil) {
                print(error?.localizedDescription)
                completion(response: .ConnectionError)
            }
            
            if let data = data {
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                print(dataString)
            }
            completion(response: .Success)
        }

        task.resume()
    }
    
    
}
