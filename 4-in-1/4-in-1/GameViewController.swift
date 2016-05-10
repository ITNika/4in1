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
        menuScene = MenuScene(fileNamed: "MenuScene.sks")
        menuScene.gvc = self
        menuScene.cm = cm
        cm?.addConnectionListener(menuScene!)
        
        //set up game scene
        gameScene = GameScene(fileNamed: "GameScene.sks")
        gameScene.gvc = self
        gameScene.cm = cm
        cm.addConnectionListener(gameScene)
        cm.addNetworkGameEventListener(gameScene)
        gameScene.addGameEventListener(cm)
        gameScene.addGameEventListener(gameScene)
        
        //set up tutorial scene
        tutorialScene = TutorialScene(fileNamed: "GameScene.sks")
        tutorialScene.gvc = self
        tutorialScene.addGameEventListener(tutorialScene)
        tutorialScene.ipadNr = 0
        tutorialScene.numberOfPlayers = 1
        
        //set up level select scene
        levelSelectScene = LevelSelectScene(size: view.bounds.size)
        levelSelectScene.gvc = self
        levelSelectScene.cm = cm
        cm.addConnectionListener(levelSelectScene)
        
        //go to menu screen, todo go to splash screen
        goToMenuScene()
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
    
    func goToGameScene(level: Int, numberOfPlayers: Int, ipadNr: Int){
        gameScene.level = level
        gameScene.ipadNr = ipadNr
        gameScene.numberOfPlayers = numberOfPlayers
        debugPrint("going to game scene with \(numberOfPlayers) players")
        presentScene(gameScene)
    }
    
    func goToTutorial(){
        presentScene(tutorialScene)
    }
    
    func goToTutorial(level: Int){
        tutorialScene.level = level
        presentScene(tutorialScene)
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
    
    func goToLevelSelecScene(numberOfPlayers: Int) {
        levelSelectScene.numberOfPlayers = numberOfPlayers
        debugPrint("going to level select scene")
        presentScene(levelSelectScene)
    }
    
    
    //GameEventListener
    func onNavigationEvent(event: GameEvent.Navigation) {
        debugPrint("received navigation event: \(GameEvent.Navigation.toString(event))")
        switch event {
        case let .startGame(level, numberOfPlayers, ipadIndex):
            goToGameScene(level, numberOfPlayers: numberOfPlayers, ipadNr: ipadIndex)
            break
        case .endGame:
            cm?.session.disconnect()
            goToMenuScene()
            break
        case let .selectLevel(count):
            goToLevelSelecScene(count)
        }
    }
    
    func onConnectionStateChange(state : MCSessionState, count: Int){
        //todo
    }
}

