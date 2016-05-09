//
//  LevelSelectScene.swift
//  4-in-1
//
//  Created by Lisa Lipkin on 05/05/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation
import SpriteKit
import MultipeerConnectivity
import CoreData

class LevelSelectScene: SKScene, Scene, ConnectionListener {
    
    var titleLabel : SKLabelNode?
    var backLable : SKLabelNode?
    var texture: SKTexture?
    var cm : ConnectivityManager?
    var gvc : GameViewController?
    var ipadNr : Int = 0
    var levels : [(level: Int, playable: Bool)]=[]
    var levelsNodes : [SKShapeNode] = []
    var numberOfPlayers : Int = 1
    
    let fontSmall : CGFloat = 28
    let fontBig : CGFloat  = 38
    
    
 
    
    override func didMoveToView(view: SKView) {
        debugPrint("moving to level select scene")
        self.backgroundColor = UIColor.whiteColor()

        
        //find levels and populate the levels list
        findLevels()
        
        
 //       //if master peer
 //       //find other players
 //         let otherPlayers : [String] = []
 //
 //           for _ in 1...otherPlayers.count{
 //               //find levels of other players
 //               let otherPlayersLevels : [(level: Int, playable: Bool)]=[]
 //               //request the levels of the other player
 //               //todo
 //
 //             //compare to master levels and set to playable if playable at other devices
//              //might have to fix indexing of arrays
//                for value in 1...otherPlayersLevels.count{
//                  if !levels[value].playable {
//                      levels[value].playable = otherPlayersLevels[value].playable
//                  }
//               }
//            }
        
                   //create a node for each level
            for value in 0...levels.count-1{
                //make circle
                let radius: CGFloat = 50
                let node = SKShapeNode(circleOfRadius: radius)
                //set color of node depending on if it's playable or not
                debugPrint(levels[value].playable)
                if levels[value].playable{
                    node.fillColor = ColorManager.colors[ColorString.teal]!
                }else{
                    node.fillColor = ColorManager.colors[ColorString.lightTeal]!
                }
                
                node.name = String(value)
                levelsNodes.append(node)
            }  //sätter position för level noderna
        
        let unit :  CGFloat = 25
        levelsNodes[0].position = CGPoint(x: CGRectGetMidX(self.scene!.frame) - (unit*9), y:CGRectGetMidY(self.scene!.frame))
        levelsNodes[1].position = CGPoint(x: CGRectGetMidX(self.scene!.frame) - (unit*3), y:CGRectGetMidY(self.scene!.frame))
        levelsNodes[2].position = CGPoint(x: CGRectGetMidX(self.scene!.frame) + unit * 3, y:CGRectGetMidY(self.scene!.frame))
        levelsNodes[3].position = CGPoint(x: CGRectGetMidX(self.scene!.frame) + unit * 9, y:CGRectGetMidY(self.scene!.frame))
        
        //lägger ut level noderna på skärmen
        for node in levelsNodes{
            self.addChild(node)
        }
        //end if masterpeer
        
        //Sätter typsnitt på texten
        self.titleLabel = SKLabelNode(fontNamed: "ChalkboardSE-bold")
        self.backLable = SKLabelNode(fontNamed: "ChalkboardSE-bold")
        
        //Sätter storleken på texten
        self.titleLabel!.fontSize = fontBig
        self.backLable!.fontSize = fontSmall

        //sätter färg på texten
        self.titleLabel!.fontColor = ColorManager.colors[ColorString.teal]
        self.backLable!.fontColor = ColorManager.colors[ColorString.teal]
        
        
        //Sätter namn på de olika noderna som syns på skärmen
        self.titleLabel!.text = "Välj nivå"
        self.backLable!.text = "Till meny"
       
        //Skapar ett namn för att kalla på noderna. (Används när någon trycker på en knapp)
        self.titleLabel!.name = "title"
        self.backLable!.name = "back"
        
        
    
        //Sätter position för noderna
        self.titleLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y:CGRectGetMidY(self.scene!.frame) + titleLabel!.frame.height + 100)
        self.backLable!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y:CGRectGetMidY(self.scene!.frame) + titleLabel!.frame.height - 200)
        
        //Lägger till noderna på skärmen
        self.addChild(self.titleLabel!)
        self.addChild(self.backLable!)
    }
    
    func findLevels(){
        debugPrint("findLevels()")
        debugPrint(numberOfPlayers)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //initialize fetch request
        let fetchRequest = NSFetchRequest()
        
        //create entity description, that is, what entities are fetched
        let entityDescription = NSEntityDescription.entityForName("Level", inManagedObjectContext: appDelegate.managedObjectContext)
        fetchRequest.entity = entityDescription
        
        //create predicate, that is, fetch only records with a certian attribute. In this case the level for the right number of users
        let predicate = NSPredicate(format: "%K == %@", "numberOfPlayers", NSNumber(integer: numberOfPlayers))
        fetchRequest.predicate = predicate
        
        //sort fetched records, that is, sort them by their level number
        let sortDescriptor = NSSortDescriptor(key: "levelNumber", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //fetch data
        do {
            debugPrint("try to fetch")
            //get instance of the appDelegate to get access to the managedObjetContext to be able to fetch from the core data. the result will be in a list
            let result = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            
            //get the length of the list, that is, the numbere of levels
            let count = result.count
            debugPrint("results")
            debugPrint(count)
            if (count > 0) {
                    //iterate over the list
                for value in 0...count-1 {
                    debugPrint(value)
                    //get a level from the result list
                    let level = result[value] as! NSManagedObject
                    
                    //get the relevant values of the level
                    let isPlayable = level.valueForKey("isPlayable") as! Bool
                    let levelNumber = level.valueForKey("levelNumber") as! Int
                    debugPrint(levelNumber)
                
                    //put the levels into to the levels array
                    levels.append((level: levelNumber, playable: isPlayable))
                }
            }
            
        }catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.menuHelper(touches)
    }
    
    func menuHelper(touches: Set<UITouch>) {
        for touch in touches {
            let nodeAtTouch = self.nodeAtPoint(touch.locationInNode(self))
            if nodeAtTouch.name == "title" {
                print("Title Label Pressed")
            }else if nodeAtTouch.name == "back"{
                print("back lable pressed")
                    cm?.fireNavigationEvent(GameEvent.Navigation.menue)
            }else{
                print("level node pressed")
                let nodeName : String = nodeAtTouch.name!
                let level : Int = Int(nodeName)!
                if(levels[level].playable){
                    cm?.fireNavigationEvent(GameEvent.Navigation.startGame(level: level, ipadIndex: 0))
                }
            }
        }
    }
    
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
  
    
    
    //Connection Listener
    /*
     func handleMessage(message: String){
     // do something?
     }*/
    
    func onConnectionStateChange(state : MCSessionState){
        switch(state) {
        case .NotConnected: self.view?.scene?.backgroundColor = UIColor.redColor()
            break
        case .Connecting: self.view?.scene?.backgroundColor = UIColor.blueColor()
            break
        case .Connected: self.view?.scene?.backgroundColor = UIColor.greenColor()
            break
        }
    }
    
    
}
