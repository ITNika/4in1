//
//  Portal.swift
//  4-in-1
//
//  Created by Alexander on 28/04/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation
import SpriteKit

class Portal: ColoredEntity {
    static private var counter: Int = 0
    static let entityName = "portal"
    let id: Int
    let name: String
    var position: CGPoint
    let color: UIColor
    
    init(x: CGFloat, y: CGFloat, color: UIColor) {
        self.position = CGPointMake(x, y)
        self.color = color
        self.id = Portal.newId()
        self.name = "\(Portal.entityName) \(self.id)"
    }
    
    static func newId() -> Int {
        let newId =  Portal.counter
        Portal.counter += 1
        return newId
    }

}