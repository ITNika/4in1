//
//  CategoryMask.swift
//  4-in-1
//
//  Created by Alexander on 03/05/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation

class CategoryMask {
    /*  CONTACT   | player    |   button  |   Wall      |      /* COLLISION   | player    |   button  | Wall(on/off)|
     -----------------------------------------------------       --------------------------------------------------
     | player      |  yes      |   yes     | no          |      | player       |  yes      |   yes     | yes/no      |
     -----------------------------------------------------       --------------------------------------------------
     | button      |  yes      |   -       | -           |      | button       |  no       |   -       | -           |
     -----------------------------------------------------      --------------------------------------------------
     | obstacles   |  no       |   -       | -           |      | obstacles    |  no       |   -       | -           |
     ----------------------------------------------------*/    -----------------------------------------------------*/
    //Category mask values
    static let noCategory: UInt32 = 0x1 << 0
    static let playerCategory: UInt32  = 0x1 << 1
    static let buttonCategory: UInt32  = 0x1 << 2
    static let wallOnCategory: UInt32 = 0x1 << 3
    static let wallOffCategory: UInt32 = 0x1 << 4
    static let portalCategory: UInt32 = 0x1 << 5 // todo ^- add portal to tables
}
