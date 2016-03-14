//
//  Button .swift
//  Four-in-One
//
//  Created by Alexander on 10/03/16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import Foundation
import UIKit

class Button: ColoredEntity {
    static private var counter: Int = 0
    static let entityName = "button"
    let id: Int
    let name: String
    var position: CGPoint
    let color: UIColor
    
    var state: ButtonState = .NOT_PRESSED {
        didSet {
            debugPrint("new state: \(self.state)")
        }
    }
    
    var listeners: [ButtonListener] = []

    init(x: CGFloat, y: CGFloat, color: UIColor) {
        self.id = Button.newId()
        self.color = color
        self.name = "\(Button.entityName) \(self.id)"
        self.position = CGPointMake(x,y)
    }
    
    func unpress(){
        self.state = .NOT_PRESSED
    }
    
    func press(player: Player){
        self.state = (player.color === self.color) ? .PRESSED_RIGHT_COLOR : .PRESSED_WRONG_COLOR
    }
    
    static func newId()-> Int {
        let newId = Button.counter
        Button.counter += 1
        return newId
    }

}