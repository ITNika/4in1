//
//  Tutorial_3.swift
//  Four-in-One
//
//  Created by Alexander on 14/03/16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import Foundation
import UIKit

class Tutorial_3: GameScene {
    let number = 3
    
    override func initGameScene(){
        /********************************
         COLORS
         ********************************/
         
         // create some colors
        let blue = UIColor.blueColor()
        let red = UIColor.redColor()
        
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
        OBSTACLES
        ********************************/
        
        let wall = Obstacle(x: screenWidth/2, y: screenHeight/2 , color: blue, width: 50, height: screenHeight)
        
        // create wall node
        let wallNode = createShapeNodeFromModel(wall)!
        
        // add wall to scene
        scene!.addChild(wallNode)
        
        //add to abstacles
        obstacles[wallNode.name!] = wall
        
        /********************************
         BUTTONS
         ********************************/
         
         // create blue and red button
        let blueButton = Button(x: 300, y: 100, color: blue)
        let redButton = Button(x: 800, y: 600, color: red)
        
        //create blue and red button node
        let blueButtonNode = createShapeNodeFromModel(blueButton)!
        let redButtonNode = createShapeNodeFromModel(redButton)!
        
        //add blue and red button to scene
        scene!.addChild(blueButtonNode)
        scene!.addChild(redButtonNode)
        
        //add blue and red button to buttons
        buttons[blueButtonNode.name!] = blueButton
        buttons[redButtonNode.name!] = redButton
        
        //add blue wall as button listener
        blueButton.listeners.append(wall)
        
        /********************************
         PLAYERS
         ********************************/
         
         // create players
        let bluePlayer = Player(x: 100, y: 100, color: blue)
        let redPlayer = Player(x: 400, y: 700, color: red)
        
        // create player Nodes
        let bluePlayerNode = createShapeNodeFromModel(bluePlayer)!
        let redPlayerNode = createShapeNodeFromModel(redPlayer)!
        
        // add player node to scene
        scene!.addChild(bluePlayerNode)
        scene!.addChild(redPlayerNode)
        
        // add to players....
        players[bluePlayerNode.name!] = bluePlayer
        players[redPlayerNode.name!] = redPlayer
        
    }
    
    override func gameOver(){
        //reset()
        if gvc != nil {
            gvc!.goToMenu()
        }
    }
    
}