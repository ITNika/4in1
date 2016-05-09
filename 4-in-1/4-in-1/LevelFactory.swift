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

    static func getEntities(numberOfPlayers: Int, ipadIndex: Int, scene: GameScene) -> (characters: [Character], buttons: [Button], obstacles:  [Obstacle], portals: [Portal])? {
        switch numberOfPlayers {
        case 2:
            return LevelWith2Players(ipadIndex, scene: scene)
        default:
            return nil
        }
    }
    
    static func LevelWith2Players(ipadIndex: Int, scene: GameScene) ->([Character], [Button], [Obstacle], [Portal])? {
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
            let yellowPortal = Portal(x: screenWidth - 150, y: screenHeight/2 , color: yellowColor)
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
            let yellowPortal = Portal(x: screenWidth*0.4, y: 150, color: yellowColor)
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
    }

}