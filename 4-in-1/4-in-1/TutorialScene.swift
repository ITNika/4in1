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
    var touch = false
    //animations
    var rightHand : SKSpriteNode?
    var instructionLabel : SKLabelNode?
    
    

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        //Sätter typsnitt på texten
        self.instructionLabel = SKLabelNode(fontNamed: "HelveticaNeue-thin")
        //Sätter storleken på texten
        self.instructionLabel!.fontSize = 48
        //sätter färg på texten
        self.instructionLabel!.fontColor = ColorManager.colors[ColorString.text]
        //Sätter position för texten
        let swipeRight = SKAction.moveToX(self.size.width-150, duration: 1.5)
        let moveLeft = SKAction.moveToX(150, duration: 0)
        let actionsRight = SKAction.sequence([swipeRight, super.fadeOut, moveLeft, super.fadeIn])
        let repeatsRight = SKAction.repeatActionForever(actionsRight)
        swipeRight.timingFunction = {sin($0*Float(M_PI_2))}
        
        rightHand = SKSpriteNode(imageNamed: "hand_right")
        rightHand!.zPosition = 6
        switch level {
        case 0:
            rightHand!.position = CGPoint(x: 150, y:325)
            self.instructionLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y:CGRectGetMidY(self.scene!.frame)*1.5)
            self.instructionLabel!.text = "Dra spelaren till knappen!"
            scene?.addChild(rightHand!)
            rightHand!.runAction(repeatsRight)
            break
        case 1:
            self.instructionLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y:CGRectGetMidY(self.scene!.frame)*1.8)
            self.instructionLabel!.text = "Dra spelarna till knapp av samma färg!"
            break
        case 2:
            self.instructionLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame)*1.5, y:CGRectGetMidY(self.scene!.frame))
            self.instructionLabel!.fontSize = 32
            self.instructionLabel!.text = "Försök öppna väggen!"
            break
        case 3:
            break
        default:
            break
        }
        self.addChild(self.instructionLabel!)
        
        
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            super.touchesBegan(touches, withEvent: event)
            rightHand!.removeFromParent()
        
    }
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
        case .openDoor(_):
            if level == 2 {
                self.instructionLabel!.text = "Dra rätt spelare till rätt plats!"
            }
        case .closeDoor(_):
            if level == 2 {
                self.instructionLabel!.text = "Försök öppna väggen!"
            }
            //spawnCharacter(ColorManager.colors[characterColor]!)
            break
        default:
            break
        }
    }
}