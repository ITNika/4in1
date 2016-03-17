//
//  Wall.swift
//  Four-in-One
//
//  Created by Andreas Henriksson on 2016-03-17.
//  Copyright © 2016 Alexander. All rights reserved.
//

import Foundation
import UIKit

class Wall: Entity{
    static private var counter: Int = 0
    static let entityName = "wall"
    let id: Int
    let name: String
    var position: CGPoint
    var width, height: CGFloat
    
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat){
        self.width = width
        self.height = height
        self.position = CGPointMake(x, y)
        self.id = Wall.newId()
        self.name = "\(Wall.entityName) \(self.id)"
    }
    static func newId() -> Int {
        let newId = Wall.counter
        Wall.counter += 1
        return newId
    }
}
