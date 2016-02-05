//
//  HNString.swift
//  HackTheNorth
//
//  Created by Si Te Feng on 8/26/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit

class HNString: NSObject {
   
    class func stringSeparatedWithCommaWithStringArray(stringArray: [String]) -> String {
        var string: String = ""
        
        for str in stringArray {
            string += str + " • "
        }
        
        if string.characters.count > 3 {
            string = (string as NSString).substringToIndex(string.characters.count - 3)
        }
        
        return string
    }
    
}
