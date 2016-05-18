//
//  Rotation.swift
//  4-in-1
//
//  Created by Mikael Lönn on 18/05/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation
import UIKit

enum Rotation {
    case NORTH
    case EAST
    case SOUTH
    case WEST
    
    static func getRad(rotation: Rotation) -> CGFloat {
        switch rotation {
        case .NORTH:
            return 0
        case .EAST:
            return CGFloat(-M_PI_2)
        case .SOUTH:
            return CGFloat(M_PI)
        case .WEST:
            return CGFloat(M_PI_2)
        }
    }
}