//
//  LevelFactory.swift
//  4-in-1
//
//  Created by Alexander on 04/05/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation
import SpriteKit

class LevelFactory {

    static func getEntities(level: Int, numberOfPlayers: Int, ipadIndex: Int, scene: GameScene) -> (characters: [Character], buttons: [Button], obstacles:  [Obstacle], portals: [Portal])? {
        debugPrint("getting entities for level \(level) for \(numberOfPlayers) players with index \(ipadIndex)")
        let screenWidth: CGFloat = scene.size.width
        let screenHeight: CGFloat = scene.size.height
        switch numberOfPlayers {
        case 1:
            return tutorialLevel(level, screenWidth: screenWidth, screenHeight: screenHeight)
        case 2:
            return levelWith2Players(level, ipadIndex: ipadIndex, scene: scene)
        case 3:
            return nil
        case 4:
            return levelWith4Players(level, ipadIndex: ipadIndex, screenWidth: screenWidth, screenHeight: screenHeight)
        default:
            return nil
        }
    }
    
    static func tutorialLevel(level: Int, screenWidth: CGFloat, screenHeight: CGFloat) ->([Character], [Button], [Obstacle], [Portal])? {
        //set up arrays
        var characters = [Character]()
        var obstacles = [Obstacle]()
        var buttons = [Button]()
        var portals = [Portal]()
        
        //colors
        let salmonColor = ColorManager.colors[ColorString.salmon]!
        let purpleColor = ColorManager.colors[ColorString.purple]!
        let tealColor = ColorManager.colors[ColorString.teal]!
        let yellowColor = ColorManager.colors[ColorString.yellowDark]!
        
        let offset: CGFloat = 150
        
        switch level {
        case 0:
            /********************************
             BUTTONS
             ********************************/
            // create teal button
            let tealButton = Button(x: screenWidth - offset, y: screenHeight / 2, color: tealColor)
            buttons.append(tealButton)
            
            /********************************
             PLAYERS
             ********************************/
            
            // create players
            let tealPlayer = Character(x: offset, y: screenHeight / 2, color: tealColor)
            // add to players....
            characters.append(tealPlayer)
            break
        case 1:
            /********************************
             BUTTONS
             ********************************/
            // create blue and red button
            let tealButton = Button(x: offset, y: screenHeight / 2  -  offset, color: tealColor)
            let salmonButton = Button(x: screenWidth - offset, y: screenHeight / 2 + offset, color: salmonColor)
            
            //add blue and red button to buttons
            buttons.append(tealButton)
            buttons.append(salmonButton)
            
            /********************************
             PLAYERS
             ********************************/
            
            // create players
            let salmonPlayer = Character(x: offset,  y: screenHeight / 2 +  offset, color: salmonColor)
            let tealPlayer = Character(x: screenWidth - offset, y: screenHeight / 2  - offset, color: tealColor)
            
            // add to players....
            characters.append(tealPlayer)
            characters.append(salmonPlayer)
            break
        case 2:
            /********************************
             OBSTACLES
             ********************************/
            let wall = Obstacle(x: screenWidth/2, y: screenHeight/2 , color: tealColor, width: 75, height: screenHeight)
            //add to abstacles
            obstacles.append(wall)
            
            /********************************
             BUTTONS
             ********************************/
            
            // create blue and red button
            let tealButton = Button(x: 300, y: 100, color: tealColor)
            let salmonButton = Button(x: 800, y: 600, color: salmonColor)

            //add blue and red button to buttons
            buttons.append(tealButton)
            buttons.append(salmonButton)

            /********************************
             PLAYERS
             ********************************/
            
            // create players
            let tealPlayer = Character(x: 100, y: 100, color: tealColor)
            let salmonPlayer = Character(x: 400, y: 700, color: salmonColor)
            // add to players....
            characters.append(tealPlayer)
            characters.append(salmonPlayer)
            
            break
        case 3:
            /********************************
             BUTTONS
             ********************************/
            // create teal button
            let tealButton = Button(x: screenWidth - offset, y: screenHeight / 2, color: tealColor)
            buttons.append(tealButton)
            
            /********************************
             PLAYERS
             ********************************/
            
            // create players
            let tealPlayer = Character(x: offset, y: screenHeight / 2, color: tealColor)
            // add to players....
            characters.append(tealPlayer)
            
            
            /********************************
             OBSTACLES
             ********************************/
            let wall = Obstacle(x: screenWidth/2, y: screenHeight/2 , color: salmonColor, width: 75, height: screenHeight)
            //add to abstacles
            obstacles.append(wall)
            
            /********************************
             PORTALS
             ********************************/
            let portal1 = Portal(x: offset, y: offset, color: purpleColor, name: "A", destination: "B")
            let portal2 = Portal(x: screenWidth - offset, y: offset, color: purpleColor, name: "B", destination: "A")
            
            portals.append(portal1)
            portals.append(portal2)
            
            break
        default:
            break
        }
        return (characters: characters, buttons: buttons, obstacles: obstacles, portals: portals)
        
    }
    
    static func levelWith2Players(level: Int, ipadIndex: Int, scene: GameScene) ->([Character], [Button], [Obstacle], [Portal])? {
        //set up arrays
        var characters = [Character]()
        var obstacles = [Obstacle]()
        var buttons = [Button]()
        var portals = [Portal]()
        
        //colors
        let salmonColor = ColorManager.colors[ColorString.salmon]!
        let purpleColor = ColorManager.colors[ColorString.purple]!
        let tealColor = ColorManager.colors[ColorString.teal]!
        let yellowColor = ColorManager.colors[ColorString.yellowDark]!
        
        switch level {
        case 0:
            switch ipadIndex {
            case 0:
                /********************************
                 OBSTACLES
                 ********************************/
                let screenWidth: CGFloat = scene.size.width
                let screenHeight: CGFloat = scene.size.height
                
                let purpleObstacle = Obstacle(x: screenWidth*0.6, y: screenHeight/2 , color: purpleColor, width: 75, height: screenHeight)
                
                obstacles.append(purpleObstacle)
                
                /********************************
                 BUTTONS
                 ********************************/
                
                // create blue and red button
                let salmonButton = Button(x: 150, y: 150, color: salmonColor)
                
                //add blue and red button to buttons
                buttons.append(salmonButton)
                
                
                /********************************
                 PORTALS
                 ********************************/
                let yellowPortal = Portal(x: screenWidth - 150, y: screenHeight/2 , color: yellowColor, name: "A", destination: "B")
                portals.append(yellowPortal)
                
                /********************************
                 PLAYERS
                 ********************************/
                
                // create players
                let tealPlayer = Character(x: 150, y: screenHeight-150, color: tealColor)
                
                // add to players....
                characters.append(tealPlayer)
                break
            case 1:
                /********************************
                 OBSTACLES
                 ********************************/
                let screenWidth: CGFloat = scene.size.width
                let screenHeight: CGFloat = scene.size.height
                
                let salmonObstacle = Obstacle(x: screenWidth*0.6, y: screenHeight/2 , color: salmonColor, width: 75, height: screenHeight)
                let tealObstacle = Obstacle(x: (screenWidth*0.6-(75/2))*0.5, y: screenHeight/2 , color: tealColor, width: screenWidth*0.6-(75/2), height: 75)
                obstacles.append(salmonObstacle)
                obstacles.append(tealObstacle)
                
                /********************************
                 BUTTONS
                 ********************************/
                
                // create blue and red button
                let purpleButton = Button(x: screenWidth - 150, y: screenHeight - 150, color: purpleColor)
                let tealButton = Button(x: 150, y: screenHeight - 150, color: tealColor)
                
                //add blue and red button to buttons
                buttons.append(purpleButton)
                buttons.append(tealButton)
                
                /********************************
                 PORTALS
                 ********************************/
                let yellowPortal = Portal(x: screenWidth*0.4, y: 150, color: yellowColor, name: "B", destination: "A")
                portals.append(yellowPortal)
                
                /********************************
                 PLAYERS
                 ********************************/
                
                // create players
                let salmonPlayer = Character(x: 150, y: 150, color: salmonColor)
                let purplePlayer = Character(x: screenWidth - 150, y: 150, color: purpleColor)
                
                // add to players....
                characters.append(salmonPlayer)
                characters.append(purplePlayer)
                break
            default:
                return nil
            }
            return (characters: characters, buttons: buttons, obstacles: obstacles, portals: portals)
        default:
            return nil
        }
    }
    
    static func levelWith4Players(level: Int, ipadIndex: Int, screenWidth: CGFloat, screenHeight: CGFloat) -> ([Character], [Button], [Obstacle], [Portal])? {
        //set up arrays
        var characters = [Character]()
        var obstacles = [Obstacle]()
        var buttons = [Button]()
        var portals = [Portal]()
        
        //colors
        let salmonColor = ColorManager.colors[ColorString.salmon]!
        let purpleColor = ColorManager.colors[ColorString.purple]!
        let tealColor = ColorManager.colors[ColorString.teal]!
        let yellowColor = ColorManager.colors[ColorString.yellowDark]!
        
        
        let offset: CGFloat = 150
        
        switch level {
        case 0:
            switch ipadIndex {
            case 0:
                //buttons
                let purpleButton = Button(x: screenWidth - offset, y: screenHeight - offset, color: purpleColor)
                buttons.append(purpleButton)
                //character
                let salmonCharacter = Character(x: screenWidth - offset, y: offset, color: salmonColor)
                characters.append(salmonCharacter)
                //obstacle
                let salmonObstacle = Obstacle(x: screenWidth*0.4, y: screenHeight/2, color: salmonColor,
                                              width: 75, height: screenHeight)
                obstacles.append(salmonObstacle)
                //portals
                let yellowPortal = Portal(x: offset, y: screenHeight / 2, color: yellowColor, name: "A", destination: "B")
                portals.append(yellowPortal)
                break
            case 1:
                //buttons
                let yellowButton = Button(x: screenWidth - offset, y: offset, color: yellowColor)
                buttons.append(yellowButton)
                //character
                let tealCharacter = Character(x: screenWidth/2, y: screenHeight/2, color: tealColor)
                characters.append(tealCharacter)
                //obstacle
                let purpleObstacle = Obstacle(x: screenWidth*0.2, y: screenHeight/2, color: purpleColor,
                                              width: 75, height: screenHeight)
                obstacles.append(purpleObstacle)
                //portals
                let yellowPortal = Portal(x: screenWidth*0.75, y: screenHeight - offset, color: yellowColor, name: "B", destination: "A")
                let tealPortal = Portal(x: offset, y: screenHeight / 2, color: tealColor, name: "C", destination: "D")
                portals.append(yellowPortal)
                portals.append(tealPortal)
                break
            case 2:
                //buttons
                let salmonButton = Button(x: offset, y: screenHeight - offset, color: salmonColor)
                buttons.append(salmonButton)
                //character
                let purpleCharacter = Character(x: screenWidth/2, y: screenHeight/2, color: purpleColor)
                characters.append(purpleCharacter)
                //obstacle
                let tealObstacle = Obstacle(x: screenWidth*0.8, y: screenHeight/2, color: tealColor,
                                              width: 75, height: screenHeight)
                obstacles.append(tealObstacle)
                //portals
                       let tealPortal = Portal(x: screenWidth*0.25, y: offset, color: tealColor, name: "D", destination: "C")
                
                let purplePortal = Portal(x: screenWidth - offset, y: screenHeight/2, color: purpleColor, name: "E", destination: "F")

                portals.append(purplePortal)
                portals.append(tealPortal)
                break
            case 3:
                //buttons
                let tealButton = Button(x: screenWidth - offset, y: screenHeight - offset, color: tealColor)
                buttons.append(tealButton)
                //character
                let yellowCharacter = Character(x: screenWidth - offset, y: offset, color: yellowColor)
                characters.append(yellowCharacter)
                //obstacle
                let yellowObstacle = Obstacle(x: screenWidth*0.4, y: screenHeight/2, color: yellowColor,
                                              width: 75, height: screenHeight)
                obstacles.append(yellowObstacle)
                //portals
                let purplePortal = Portal(x: offset, y: screenHeight / 2, color: purpleColor, name: "F", destination: "E")
                portals.append(purplePortal)
                break
            default:
                break
            }
        default:
            break
        }
        
        return (characters: characters, buttons: buttons, obstacles: obstacles, portals: portals)
    }

}