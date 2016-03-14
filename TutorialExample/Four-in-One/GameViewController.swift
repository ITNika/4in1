//
//  GameViewController.swift
//  Four-in-One
//
//  Created by Alexander on 09/03/16.
//  Copyright (c) 2016 Alexander. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var debug: Bool = true

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("viewDidLoad")
        goToMenu()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
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
    
    /***************************************
            Scene Navigation
    ***************************************/
    
    func getTutorialScene(number: Int) -> GameScene? {
        
    
        switch number {
            case 1: return Tutorial_1(fileNamed: "GameScene")
            case 2: return Tutorial_2(fileNamed: "GameScene")
            case 3: return Tutorial_3(fileNamed: "GameScene")
            default: return nil
        }
    }
    
    func goToTutorial(number: Int){
        if let scene = getTutorialScene(number) {
            //go to tutorial scene
            scene.gvc = self
            goToScene(scene, debug: self.debug)
        }
    }
    
    func goToMenu(){
        if let scene = MenuScene(fileNamed: "MenuScene"){
            // Configure the view.
            debugPrint("goingToMenu")
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
