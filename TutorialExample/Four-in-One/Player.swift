//
//  player.swift
//  Four-in-One
//
//  Created by Alexander on 09/03/16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import Foundation
import UIKit

class Player: ColoredEntity {
    static private var counter: Int = 0
    static let entityName = "player"
    let id: Int
    let name: String
    var position: CGPoint
    let color: UIColor
    
    init(x: CGFloat, y: CGFloat, color : UIColor) {
        self.position = CGPointMake(x,y)
        self.id  = Player.newId()
        self.color = color
        self.name = "\(Player.entityName) \(self.id)"
    }
    
    static func newId() -> Int {
        let newId = Player.counter
        Player.counter += 1
        return newId
    }
}
