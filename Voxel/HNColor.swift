//
//  HNStyle.swift
//  HackTheNorth
//
//  Created by Si Te Feng on 8/18/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit

public enum HNColorTypes {
    case NavigationBarColor
    case MainBGColor, SecondaryBGColor
    case MainTextColor, SecondaryTextColor
    case OrangeActionColor
    case WhiteTransluscent
}

extension UIColor {
    
    /* Color With Hex Value
    var strokeColor = UIColor(rgba: "#ffcc00").CGColor // Solid color
    var fillColor = UIColor(rgba: "#ffcc00dd").CGColor // Color with alpha
    var backgroundColor = UIColor(rgba: "#FFF") // Supports shorthand 3 character representation
    var menuTextColor = UIColor(rgba: "#013E") // Supports shorthand 4 character representation (with alpha)
    */
    public convenience init(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let index   = rgba.startIndex.advancedBy(1)
            let hex     = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                switch (hex.characters.count) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
                }
            } else {
                print("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    
    public convenience init?(colorType: HNColorTypes) {
        var color: UIColor
        
        switch colorType {
            case .NavigationBarColor:
                color = UIColor(rgba: "#2068A8")
            case .MainBGColor:
                color = UIColor(rgba: "#0F2C49")
            case .SecondaryBGColor:
                color = UIColor(rgba: "#16426E")
            case .MainTextColor:
                color = UIColor.whiteColor()
            case .SecondaryTextColor:
                color = UIColor(rgba: "#A7C3D6")
            case .OrangeActionColor:
                color = UIColor(rgba: "#FFA500")
            case .WhiteTransluscent:
                color = UIColor.whiteColor().colorWithAlphaComponent(0.4)
            default:
                color = UIColor.grayColor()
        }
        
        self.init(CGColor: color.CGColor)
    }
    
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}

