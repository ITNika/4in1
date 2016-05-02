//
//  ColorManager.swift
//  4-in-1
//
//  Created by Alexander on 02/05/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation
import UIKit

class ColorManager {
    //color strings
    static let blueStr = "blue"
    static let redStr = "red"
    
    //color map
    static let colors: [String : UIColor]  = [
            blueStr : UIColor.blueColor(),
            redStr : UIColor.redColor()//,
            //...
            ]
    
    // return string representation of an UIColor, e.g. "blue" or "red"
    static func getColorString(color: UIColor) -> String?{
        for key in colors.keys {
            if color === colors[key] {
                return key
            }
        }
        return nil
    }
    
    
}