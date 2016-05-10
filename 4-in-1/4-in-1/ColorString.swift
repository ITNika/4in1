//
//  ColorStrings.swift
//  4-in-1
//
//  Created by Alexander on 03/05/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation

enum ColorString : String { //no spaces allowed, eg. use lightBlue instead of light blue
    /******************
     R G B
    *******************/
    case red = "red"
    case green  = "green"
    case blue = "blue"
    
    /******************
     P U R P L E
     *******************/
    case purple = "purple"
    case purpleDark = "purpleDark"
    
    /******************
     T E A L
     *******************/
    case teal = "teal"
    case tealLight = "tealLight"
    case tealDark = "tealDark"
    
    /******************
     Y E L L O W
     *******************/
    case yellow = "yellow"
    case yellowDark = "yellowDark"
    
    /******************
     S A L M O N
     *******************/
    case salmon = "salmon"
    case salmonDark = "salmonDark"
    
    /******************
     T E X T
    *******************/
    case text = "text" 
    
    //...
}