//
//  ColoredEntity.swift
//  4-in-1
//
//  Created by Alexander on 17/03/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation
import UIKit

protocol ColoredEntity: Entity {
    var color: UIColor {get}
}