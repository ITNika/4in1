//
//  Tutorial_1.swift
//  Four-in-One
//
//  Created by Alexander on 14/03/16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import Foundation
import UIKit

class Tutorial_1: GameScene {
    let number = 1
    
    override func initGameScene(){
        let offset: CGFloat = 150
        
        /********************************
         COLORS
         ********************************/
         
        // create some colors
        let blue = UIColor.blueColor()
        
        /********************************
        WALLS
        ********************************/
        
        // create wall model
        scene!.scaleMode = .AspectFill
        let screenWidth: CGFloat = scene!.size.width
        let screenHeight: CGFloat = scene!.size.height
        let borderWalls = [
            Wall(x: 0, y: screenHeight/2 , width: 1, height: screenHeight),
            Wall(x: screenWidth/2, y: 0 , width: screenWidth, height: 1),
            Wall(x: screenWidth, y: screenHeight/2 , width: 1, height: screenHeight),
            Wall(x: screenWidth/2, y: screenHeight , width: screenWidth, height: 1)
            
        ]
        for borderWall in borderWalls{
            // create wall node
            let wallNode = createShapeNodeFromModel(borderWall)!
            
            // add wall to scene
            scene!.addChild(wallNode)
            
            
        }

        
        /********************************
         BUTTONS
         ********************************/
         
         // create blue button
        let blueButton = Button(x: self.view!.frame.width - offset, y: CGRectGetMidY(self.view!.bounds), color: blue)

        
        //create blue node
        let blueButtonNode = createShapeNodeFromModel(blueButton)!

        
        //add blue button to scene
        scene!.addChild(blueButtonNode)
        
        //add blue  button to buttons
        buttons[blueButtonNode.name!] = blueButton
        
        /********************************
         PLAYERS
         ********************************/

         // create players
        let bluePlayer = Player(x: offset, y: CGRectGetMidY(self.view!.bounds), color: blue)
        
        // create player Nodes
        let bluePlayerNode = createShapeNodeFromModel(bluePlayer)!
        
        // add player node to scene
        scene!.addChild(bluePlayerNode)
        
        // add to players....
        players[bluePlayerNode.name!] = bluePlayer
        
    }
    
    override func gameOver(){
        debugPrint("tut1")
        //reset()
        if gvc != nil {
            gvc!.goToTutorial(number + 1)
        }
    }

}