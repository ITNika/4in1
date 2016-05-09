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

    //color map
    static let colors: [ColorString : UIColor]  = [
            ColorString.blue : UIColor.blueColor(),
            ColorString.red : UIColor.redColor(),
            ColorString.green : UIColor.greenColor(),
            ColorString.purple : UIColor(red: 0.514, green: 0.357, blue: 0.502, alpha: 1),
            ColorString.teal : UIColor(red: 0.329, green: 0.475, blue: 0.455, alpha: 1),
            ColorString.yellow : UIColor(red: 0.733, green: 0.745, blue: 0.518, alpha: 1),
            ColorString.salmon : UIColor(red: 0.757, green: 0.616, blue: 0.522, alpha: 1),
            ColorString.purpleDark : UIColor(red: 0.357, green: 0.247, blue: 0.345, alpha: 1),
            ColorString.tealDark : UIColor(red: 0.227, green: 0.329, blue: 0.314, alpha: 1),
            ColorString.yellowDark : UIColor(red: 0.586, green: 0.518, blue: 0.357, alpha: 1),
            ColorString.salmonDark : UIColor(red: 0.522, green: 0.427, blue: 0.361, alpha: 1),
            //...
            ]
    
    // return string representation of an UIColor, e.g. "blue" or "red"
    static func getColorString(color: UIColor) -> ColorString?{
        for key in colors.keys {
            if color == colors[key] {
                return key
            }
        }
        return nil
    }
}
