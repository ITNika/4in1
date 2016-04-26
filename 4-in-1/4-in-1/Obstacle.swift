//
//  Obstacle.swift
//  Four-in-One
//
//  Created by Alexander on 09/03/16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import Foundation
import UIKit

class Obstacle: ColoredEntity, ButtonListener {
    static private var counter: Int = 0
    static let entityName = "obstacle"
    let id: Int
    let name: String
    var position: CGPoint
    let color: UIColor
    var width, height: CGFloat
    
    var isActive: Bool = true {
        didSet {
            debugPrint(" \(self.name) is active: \(isActive) )")
        }
        
    }
    
    init(x: CGFloat, y: CGFloat, color: UIColor, width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        self.position = CGPointMake(x, y)
        self.color = color
        self.id = Obstacle.newId()
        self.name = "\(Obstacle.entityName) \(self.id)"
    }
    
    func onButtonStateChange(state: ButtonState){
        isActive = (state == ButtonState.NOT_PRESSED)
    }
    
    static func newId() -> Int {
        let newId = Obstacle.counter
        Obstacle.counter += 1
        return newId
    }
}