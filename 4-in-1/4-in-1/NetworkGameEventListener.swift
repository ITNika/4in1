//
//  NetworkGameEventListener.swift
//  4-in-1
//
//  Created by Alexander on 03/05/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation
protocol NetworkGameEventListener {
    func onGameEventOverNetwork(event: GameEvent)
}