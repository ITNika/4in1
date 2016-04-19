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
    var debug: Bool = true

    /*override func viewDidLoad() {
        super.viewDidLoad()
         if let scene = MenuScene(fileNamed:"MenuScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }*/
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("viewDidLoad")
        goToMenu()
    }
    
    //Scene Navigation
    
    func goToMenu(){
        if let scene = MenuScene(fileNamed: "MenuScene"){
            // Configure the view.
            debugPrint("goingToMenu")
            scene.gvc = self
            goToScene(scene, debug: self.debug)
        }
    }
    
    func goToGame(){
        if let scene = GameScene(fileNamed: "GameScene") {
            //go to tutorial scene
            scene.gvc = self
            goToScene(scene, debug: self.debug)
        }
    }
    
    func goToScene(scene: SKScene, debug: Bool){
        debugPrint("goingToScene")
        let skView = self.view as! SKView
        if debug {
            skView.showsFPS = true
            skView.showsNodeCount = true
        }
        // Sprite Kit applies additional optimizations to improve rendering performance
        skView.ignoresSiblingOrder = true
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .AspectFill
        
        // set up scene transition
        let transition = SKTransition.crossFadeWithDuration(1.0)
        
        //present scene
        skView.presentScene(scene, transition: transition)
    }
}
