//
//  TutorialScene.swift
//  4-in-1
//
//  Created by Alexander on 26/04/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation
import SpriteKit

class TutorialScene : GameScene {
    var currentTutorial = 1
    let nrOfTutorials = 3
    
    override func onInGameEvent(event: GameEvent) {
        super.onInGameEvent(event)
        switch event {
        case .gameOver:
            gvc?.goToLevelSelecScene(1)
            break
        case let .sendCharacter(characterColorStr, destination):
            let characterColor = ColorManager.colors[characterColorStr]!
            let portal = findPortalByDestination(destination)
            if portal != nil {
                spawnCharacterOnPortal(characterColor, portal: portal!)
            }
            //spawnCharacter(ColorManager.colors[characterColor]!)
            break
        default:
            break
        }
    }
}