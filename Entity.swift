//
//  Entity.swift
//  4-in-1
//
//  Created by Alexander on 17/03/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation
import UIKit

protocol Entity {
    var id: Int {get}
    var name: String {get}
    var position: CGPoint {get set}
    static func newId() -> Int
}