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

class GameViewController: UIViewController, ConnectionListener, NavigationEventListener {
    var cm : ConnectivityManager!
    var menuScene : MenuScene!
    var gameScene : GameScene!
    var tutorialScene: TutorialScene!
    var levelSelectScene : LevelSelectScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        //set up connectivity manager
        cm = ConnectivityManager()
        cm.addConnectionListener(self)
        cm.addNavigationListener(self)
        //cm?.addGameEventListener(self)
        cm.gvc = self
        
        //set up menu scene
        menuScene = MenuScene(size: view.bounds.size)
        menuScene.gvc = self
        menuScene.cm = cm
        cm?.addConnectionListener(menuScene!)
        
        //set up game scene
        gameScene = GameScene(size: view.bounds.size)
        gameScene.gvc = self
        gameScene.cm = cm
        cm.addConnectionListener(gameScene)
        cm.addNetworkGameEventListener(gameScene)
        gameScene.addGameEventListener(cm)
        gameScene.addGameEventListener(gameScene)
        
        //set up tutorial scene
        tutorialScene = TutorialScene(size: view.bounds.size)
        tutorialScene.gvc = self
        tutorialScene.addGameEventListener(tutorialScene)
        goToMenuScene()
        
        //set up level select scene
        levelSelectScene = LevelSelectScene(size: view.bounds.size)
        levelSelectScene.gvc = self
        levelSelectScene.cm = cm
        cm.addConnectionListener(levelSelectScene)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func goToMenuScene(){
        presentScene(menuScene)
    }
    
    func goToGameScene(){
        presentScene(gameScene)
    }
    
    func goToGameScene(numberOfPlayers: Int, ipadNr: Int){
        gameScene.ipadNr = ipadNr
        gameScene.numberOfPlayers = numberOfPlayers
        debugPrint("going to game scene with \(numberOfPlayers) players")
        presentScene(gameScene)
    }
    
    func goToLevelSelecScene(numberOfPlayers: Int, ipadNr:Int) {
        levelSelectScene.numberOfPlayers = numberOfPlayers
        levelSelectScene.ipadNr = ipadNr
        debugPrint("going to level select scene")
        presentScene(levelSelectScene)
    }
    
    func goToTutorial(){
        goToLevelSelecScene(2, ipadNr: 1)
    }
    
    func presentScene(scene: SKScene){
        debugPrint("presenting scene")
        let skView = view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .ResizeFill
            skView.presentScene(scene)
    }
    
    //GameEventListener
    func onNavigationEvent(event: GameEvent.Navigation) {
        debugPrint("received navigation event: \(GameEvent.Navigation.toString(event))")
        switch event {
        case let .startGame(numberOfPlayers, ipadIndex):
            goToGameScene(numberOfPlayers, ipadNr: ipadIndex)
            break
        case .endGame:
            goToMenuScene()
            break
        case let .selectLevel(numberOfPlayers, ipadIndex):
            goToLevelSelecScene(numberOfPlayers, ipadNr: ipadIndex)
        }
    }
    
    func onConnectionStateChange(state : MCSessionState){
        //todo
    }
}

