//
//  Scene.swift
//  4-in-1
//
//  Created by Alexander on 26/04/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation

protocol Scene {
    var gvc: GameViewController? {get set}
    var cm : ConnectivityManager? {get set}
}