//
//  GameScene.swift
//  BallGame
//
//  Created by GreggColeman on 7/22/15.
//  Copyright (c) 2015 Gregg Coleman. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    
    let playButton = SKSpriteNode(imageNamed: "play")
    
    override func didMoveToView(view: SKView) {
       self.playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        self.addChild(self.playButton)
        self.backgroundColor = UIColor(hex:999684)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        /* For each touch see if we can get 
            the node we are looking for */
        for touch: AnyObject in touches{
            // Get the location touched
            // within the whole scene node (self)
            let location = touch.locationInNode(self)
          
            // If we find the Sprite node as the playbutton start the game
            if(self.nodeAtPoint(location) == self.playButton){
                println("Start new game")
                
                // Create new scene object
                var newPlayscene = PlayScene(size: self.size)
                // get copy of current scene skViewObject
                let skView = self.view as SKView?
                skView!.ignoresSiblingOrder = true;
                newPlayscene.scaleMode = .ResizeFill
                // set the new scene size to be the current scene size
                newPlayscene.size = skView!.bounds.size
                skView!.presentScene(newPlayscene)
            }
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
