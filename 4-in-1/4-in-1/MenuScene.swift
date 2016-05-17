//
//  GameScene.swift
//  4in1
//
//  Created by Amanda Belfrage on 25/02/16.
//  Copyright (c) 2016 Amanda Belfrage. All rights reserved.
//

import SpriteKit
import MultipeerConnectivity

class MenuScene: SKScene, Scene, ConnectionListener {

    var texture: SKTexture?
    var gvc : GameViewController?
    var cm : ConnectivityManager?
    let fontSmall : CGFloat = 28
    let fontBig : CGFloat  = 38

    
    override func didMoveToView(view: SKView) {
        debugPrint("moving to menu scene")
        // start hosting?
        cm?.startHosting()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.menuHelper(touches)
    }
    
    func menuHelper(touches: Set<UITouch>) {
        for touch in touches {
            let nodeAtTouch = self.nodeAtPoint(touch.locationInNode(self))
            if nodeAtTouch.name == "title" {
                print("Title Label Pressed")
            }else if nodeAtTouch.name == "createGame" {
                print("New game Label Pressed")
                cm?.joinSession()
            }else if nodeAtTouch.name == "tutorial"{
                print("Tutorial Label pressed")
                gvc?.goToLevelSelecScene(1)
            }else if nodeAtTouch.name == "set"{
                print("Settings Label pressed")
            }
        }
    }

    
    func onConnectionStateChange(state : MCSessionState, count: Int){
        /*
        let node = self.childNodeWithName("connectionLabel")
        
        if let label = node as! SKLabelNode? where node != nil {
            switch(state) {
            case .NotConnected:
                label.fontColor = ColorManager.colors[ColorString.salmon]
                label.text  = "Not Connected"
                break
            case .Connecting:
                label.fontColor = ColorManager.colors[ColorString.purple]
                label.text  = "Connecting"
                break
            case .Connected:
                label.fontColor = ColorManager.colors[ColorString.teal]
                label.text  = "Connected to \(count) other players"
                break
            }
        }*/
    }
    
    
}
