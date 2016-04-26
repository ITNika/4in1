//
//  GameViewController.swift
//  4-in-1
//
//  Created by Alexander on 17/03/16.
//  Copyright (c) 2016 Chalmers. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        goToMenuScene()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func goToMenuScene(){
        let scene = MenuScene(size: view.bounds.size)
        scene.gvc = self
        presentScene(scene)
    }
    
    func goToGameScene(){
        let gameScene = GameScene(size: view.bounds.size)
        gameScene.gvc = self
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
    
}

