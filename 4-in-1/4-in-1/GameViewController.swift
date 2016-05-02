//
//  GameViewController.swift
//  4-in-1
//
//  Created by Alexander on 17/03/16.
//  Copyright (c) 2016 Chalmers. All rights reserved.
//

import UIKit
import SpriteKit
import MultipeerConnectivity

class GameViewController: UIViewController, ConnectionListener {
    var cm : ConnectivityManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cm = ConnectivityManager()
        cm?.addConnectionListener(self)
        cm!.gvc = self
        goToMenuScene()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func goToMenuScene(){
        let scene = MenuScene(size: view.bounds.size)
        scene.gvc = self
        scene.cm = cm
        cm?.addConnectionListener(scene)
        presentScene(scene)
    }
    
    func goToGameScene(){
        let gameScene = GameScene(size: view.bounds.size)
        gameScene.gvc = self
        gameScene.cm = cm
        cm?.addConnectionListener(gameScene)
        presentScene(gameScene)
    }
       
    
    func goToGameScene(ipadNr: Int){
        let gameScene = GameScene(size: view.bounds.size)
        gameScene.gvc = self
        gameScene.ipadNr = ipadNr
        cm?.addConnectionListener(gameScene)
        presentScene(gameScene)
    }
    
    func goToTutorial(){
        let tutorial = TutorialScene(size: view.bounds.size)
        tutorial.gvc = self
        presentScene(tutorial)
    }
    
    func presentScene(scene: SKScene){
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }
    //Connection Listener
    func handleMessage(message: String){
        switch message {
        case "start game":
            goToGameScene()
            break
        default: break
            
        }
    }
    
    func onConnectionStateChange(state : MCSessionState){
        //todo
    }
}

