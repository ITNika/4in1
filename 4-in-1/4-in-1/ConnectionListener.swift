//
//  ConnectionListener.swift
//  4-in-1
//
//  Created by Alexander on 28/04/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ConnectionListener {
    //func handleMessage(message : String)
    func onConnectionStateChange(state : MCSessionState)
}