//
//  Character.swift
//  4-in-1
//
//  Created by Alexander on 17/03/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation
import UIKit

class Character: ColoredEntity {
    static private var counter: Int = 0
    static let entityName = "character"
    let id: Int
    let name: String
    var position: CGPoint
    let color: UIColor
    
    init(x: CGFloat, y: CGFloat, color : UIColor) {
        self.position = CGPointMake(x,y)
        self.id  = Character.newId()
        self.color = color
        self.name = "\(Character.entityName) \(self.id)"
    }
    
    static func newId() -> Int {
        let newId = Character.counter
        Character.counter += 1
        return newId
    }
}
