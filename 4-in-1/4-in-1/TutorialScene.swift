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
    /*
    override func initGameScene() {
        debugPrint("init tutorial")
        switch(currentTutorial){
            case 1: firstTutorial()
                break
            case 2: secondTutorial()
                break
            case 3: thirdTutorial()
                break
            default: gvc?.goToMenuScene()
        }
    }
    func firstTutorial(){
        let offset: CGFloat = 150
        
        /********************************
         COLORS
         ********************************/
         
         // create some colors
        let blue = ColorManager.colors[ColorString.blue]!
        
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
        buttons.append(blueButton)
        
        /********************************
         PLAYERS
         ********************************/
         
         // create players
        let bluePlayer = Character(x: offset, y: CGRectGetMidY(self.view!.bounds), color: blue)
        
        // create player Nodes
        let bluePlayerNode = createShapeNodeFromModel(bluePlayer)!
        
        // add player node to scene
        scene!.addChild(bluePlayerNode)
        
        // add to players....
        characters.append(bluePlayer)
        
    }
    func secondTutorial(){
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
         BUTTONS
         ********************************/
        let offset: CGFloat = 150
        
        // create blue and red button
        let blueButton = Button(x: offset, y: CGRectGetMidY(self.view!.bounds) -  offset, color: blue)
        let redButton = Button(x: self.view!.frame.width - offset, y: CGRectGetMidY(self.view!.bounds) + offset, color: red)
        
        //create blue and red button node
        let blueButtonNode = createShapeNodeFromModel(blueButton)!
        let redButtonNode = createShapeNodeFromModel(redButton)!
        
        //add blue and red button to scene
        scene!.addChild(blueButtonNode)
        scene!.addChild(redButtonNode)
        
        //add blue and red button to buttons
        buttons.append(blueButton)
        buttons.append(redButton)
        
        
        /********************************
         PLAYERS
         ********************************/
         
         // create players
        let redPlayer = Character(x: offset,  y: CGRectGetMidY(self.view!.bounds) +  offset, color: red)
        let bluePlayer = Character(x: self.view!.frame.width - offset, y: CGRectGetMidY(self.view!.bounds) - offset, color: blue)
        
        
        // create player Nodes
        let bluePlayerNode = createShapeNodeFromModel(bluePlayer)!
        let redPlayerNode = createShapeNodeFromModel(redPlayer)!
        
        // add player node to scene
        scene!.addChild(bluePlayerNode)
        scene!.addChild(redPlayerNode)
        
        // add to players....
        characters.append(bluePlayer)
        characters.append(redPlayer)
    }
    func  thirdTutorial(){
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
        obstacles.append(wall)
        
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
        buttons.append(blueButton)
        buttons.append(redButton)
        
        //add blue wall as button listener
        blueButton.listeners.append(wall)
        
        /********************************
         PLAYERS
         ********************************/
         
         // create players
        let bluePlayer = Character(x: 100, y: 100, color: blue)
        let redPlayer = Character(x: 400, y: 700, color: red)
        
        // create player Nodes
        let bluePlayerNode = createShapeNodeFromModel(bluePlayer)!
        let redPlayerNode = createShapeNodeFromModel(redPlayer)!
        
        // add player node to scene
        scene!.addChild(bluePlayerNode)
        scene!.addChild(redPlayerNode)
        
        // add to players....
        characters.append(bluePlayer)
        characters.append(redPlayer)
        

    }
    override func gameOver(){
        currentTutorial += 1
        reset()
    }

*/
}