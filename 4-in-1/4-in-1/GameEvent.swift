//
//  GameEvents.swift
//  4-in-1
//
//  Created by Alexander on 03/05/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation

enum GameEvent {

    case sendCharacter(characterColor: ColorString, portal: String)
        case winning(winning: Bool, ipadNr: Int)
        case openDoor(doorColor: ColorString)
        case closeDoor(doorColor: ColorString)
        case gameOver
        
        static func toString(event: GameEvent) -> String {
            switch event {
            case let .sendCharacter(characterColor, portal):
                return "sendCharacter \(characterColor.rawValue) \(portal)"
            case let .openDoor(doorColor):
                return "openDoor \(doorColor.rawValue)"
            case let .closeDoor(doorColor):
                return "closeDoor \(doorColor.rawValue)"
         case let .winning(winning, ipadNr):
                return "winning \(winning) ipad \(ipadNr)"
            case .gameOver:
                return "gameOver"
            }
        }
        
        static func fromString(string: String) -> GameEvent? {
            let split = string.componentsSeparatedByString(" ")
            if string == "gameOver" { //test for gameOver
                return GameEvent.gameOver
            }
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
                            return .sendCharacter(characterColor: color1, portal: split[2])
                    }
                }
            }
            if split.count == 4  { //test for winning
                if split[0] == "winning" && split[2] == "ipad" {
                    let winning = ("true" == split[1]) ? true : false
                    if let ipadNr = Int(split[3]){
                        return .winning(winning: winning, ipadNr: ipadNr)
                    }
                 }
            }
            
            return nil
        }

    enum Navigation {
        case startGame(level: Int, numberOfPlayers: Int, ipadIndex: Int)
        case endGame
        case selectLevel(numberOfPlayers: Int)
        
        static func toString(event: GameEvent.Navigation) -> String {
            switch event {
            case let .startGame(level, numberOfPlayers, ipadIndex):
                return "startGame \(level) \(numberOfPlayers) \(ipadIndex)"
            case .endGame:
                return "endGame"
            case let .selectLevel(count):
                return "selectLevel \(count)"
            }
        }
        
        static func fromString(string: String) -> GameEvent.Navigation? {
            if string == "endGame" { // test for end game
                return .endGame
            }
            
            let split = string.componentsSeparatedByString(" ")
            
            if split.count == 2 {
                if split[0] == "selectLevel" {
                    if let nr = Int(split[1]){
                        return .selectLevel(numberOfPlayers: nr)
                    }
                }
            }
            
            if split.count == 4 { // test for sendCharacter
                if split[0] == "startGame" { //.. or startGame
                    if let int1 = Int(split[1]) {
                        if let int2 = Int(split[2]) {
                            if let int3 = Int(split[3]) {
                                return .startGame(level: int1, numberOfPlayers: int2, ipadIndex: int3)
                            }
                        }
                    }
                }
            }
            return nil
        }

    }
}
