//
//  GameEvents.swift
//  4-in-1
//
//  Created by Alexander on 03/05/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation

enum GameEvent {

        case sendCharacter(characterColor: ColorString, portalColor: ColorString)
        case openDoor(doorColor: ColorString)
        case closeDoor(doorColor: ColorString)
        
        static func toString(event: GameEvent) -> String {
            switch event {
            case let .sendCharacter(characterColor, portalName):
                return "sendCharacter \(characterColor.rawValue) \(portalName.rawValue)"
            case let .openDoor(doorColor):
                return "openDoor \(doorColor.rawValue)"
            case let .closeDoor(doorColor):
                return "closeDoor \(doorColor.rawValue)"
            }
        }
        
        static func fromString(string: String) -> GameEvent? {
            let split = string.componentsSeparatedByString(" ")
            
            if split.count == 2 { // test for openDoor
                if split[0] == "openDoor" {
                    if let color = ColorString(rawValue: split[1]) {
                        return .openDoor(doorColor: color)
                    }
                } else if split[0] == "closeDoor" { //test for close door
                    if let color = ColorString(rawValue: split[1]) {
                        return .closeDoor(doorColor: color)
                    }
                }
            }
            
            if split.count == 3 { // test for sendCharacter
                if split[0] == "sendCharacter" {
                    if let color1 = ColorString(rawValue: split[1]) {
                        if let color2 = ColorString(rawValue: split[2]){
                            return .sendCharacter(characterColor: color1, portalColor: color2)
                        }
                    }
                }
            }
            return nil
        }

    enum Navigation {
        case startGame(level: Int, ipadIndex: Int)
        case endGame
        
        static func toString(event: GameEvent.Navigation) -> String {
            switch event {
            case let .startGame(level, ipadIndex):
                return "startGame \(level) \(ipadIndex)"
            case .endGame:
                return "endGame"
            }
        }
        
        static func fromString(string: String) -> GameEvent.Navigation? {
            if string == "endGame" { // test for end game
                return .endGame
            }
            
            let split = string.componentsSeparatedByString(" ")
            
            if split.count == 3 { // test for sendCharacter
                if split[0] == "startGame" { //.. or startGame
                    if let int1 = Int(split[1]) {
                        if let int2 = Int(split[2]) {
                            return .startGame(level: int1, ipadIndex: int2)
                        }
                    }
                }
            }
            return nil
        }

    }
}
