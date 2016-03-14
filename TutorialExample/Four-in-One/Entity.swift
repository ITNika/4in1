//
//  Entity.swift
//  Four-in-One
//
//  Created by Alexander on 11/03/16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import Foundation
import UIKit 

protocol Entity {
    var id: Int {get}
    var name: String {get}
    var position: CGPoint {get set}
    static func newId() -> Int
}