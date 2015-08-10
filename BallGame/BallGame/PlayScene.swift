//
//  PlayScene.swift
//  BallGame
//
//  Created by CSR Solutions on 7/23/15.
//  Copyright (c) 2015 Gregg Coleman. All rights reserved.
//

import SpriteKit

class PlayScene: SKScene, SKPhysicsContactDelegate{
    
    let runningBar = SKSpriteNode(imageNamed:"bar")
    let hero = SKSpriteNode(imageNamed:"hero")
    let block1 = SKSpriteNode(imageNamed:"block1")
    let block2 = SKSpriteNode(imageNamed:"block2")
    let scoreText = SKLabelNode(fontNamed: "Chalkduster")
    
    var origRunningBarPositionX = CGFloat(0);
    var maxBarX = CGFloat(0)
    var groundSpeed = 5
    var onGround = true
    
    // Y velocity because we are jumping which is up the Y-AXIS
    var velocityY = CGFloat(0)
    var heroBaseLine = CGFloat(0)
    let gravity = CGFloat(0.6);
    
    
    var blockMaxX = CGFloat(0)
    var origBlockPositionX = CGFloat(0)
    var score = 0
    
    enum ColliderType:UInt32{
        case Hero = 1
        case Block = 2
    }
    
    
    var blockStatuses:Dictionary<String,BlockStatus> = [:]
    
    override func didMoveToView(view: SKView) {
        println("We are at the new scene")
         self.backgroundColor = UIColor(hex:999684)
        
        // Allows wiring up responses for the contact / collision
        self.physicsWorld.contactDelegate = self
        
        // set up collision detection
        self.hero.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.hero.size.width / 2))
        self.hero.physicsBody?.affectedByGravity = false
        self.hero.physicsBody?.categoryBitMask = ColliderType.Hero.rawValue
        self.hero.physicsBody?.contactTestBitMask = ColliderType.Block.rawValue
        self.hero.physicsBody?.collisionBitMask = ColliderType.Block.rawValue
        
        
        self.block1.physicsBody = SKPhysicsBody(rectangleOfSize: self.block1.size)
        self.block1.physicsBody?.dynamic = false
        self.block1.physicsBody?.categoryBitMask = ColliderType.Block.rawValue
        self.block1.physicsBody?.contactTestBitMask = ColliderType.Hero.rawValue
        self.block1.physicsBody?.collisionBitMask = ColliderType.Hero.rawValue
      
        self.block2.physicsBody = SKPhysicsBody(rectangleOfSize: self.block2.size)
        self.block2.physicsBody?.dynamic = false
        self.block2.physicsBody?.categoryBitMask = ColliderType.Block.rawValue
        self.block2.physicsBody?.contactTestBitMask = ColliderType.Hero.rawValue
        self.block2.physicsBody?.collisionBitMask = ColliderType.Hero.rawValue
        

        
        
        // make the location where all things are measured
        // or the Anchor point half way up the bar
        self.runningBar.anchorPoint = CGPointMake(0 , 0.5)
        
        // Set the bars podition to on bottom of screen
        // by setting the min and max position to be the frame plus
        // half the bar size
        self.runningBar.position =
            CGPointMake(CGRectGetMinX(self.frame),
            CGRectGetMinY(self.frame) + (self.runningBar.size.height / 2) + (self.hero.size.height / 2))
    
        self.origRunningBarPositionX = self.runningBar.position.x
        self.maxBarX = (self.runningBar.size.width - self.frame.size.width)
        // Multiply by negative to make sure we are maxing all the way to the right / end
        self.maxBarX *= -1
        
        // Set the starting point on the y-axis  for the hero
        // The  starting point is the anchor point / 2 because the anchor point
        // on the bar is in the center
        self.heroBaseLine = self.runningBar.position.y + (self.runningBar.size.height / 2) + (self.hero.size.height / 2)
        
        // Set the starting position
        self.hero.position = CGPointMake(CGRectGetMinX(self.frame) + self.hero.size.width +
            (self.hero.size.width / 4) , self.heroBaseLine)
        
        self.block1.position = CGPointMake(CGRectGetMaxX(self.frame) + self.block1.size.width, self.heroBaseLine)
        self.block2.position = CGPointMake(CGRectGetMaxX(self.frame) + self.block2.size.width, self.heroBaseLine + self.block1.size.height / 2)
        
        self.origBlockPositionX = self.block1.position.x
        
        self.block1.name = "block1"
        self.block2.name = "block2"
        
        blockStatuses["block1"] = BlockStatus(isRunning: false, timeGapForNextRun: random(), currentInterval: UInt32(0))
        
        blockStatuses["block2"] = BlockStatus(isRunning: false, timeGapForNextRun: random(), currentInterval: UInt32(0))
        
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        self.blockMaxX = 0 - self.block1.size.width / 2
        
        self.addChild(self.runningBar)
        self.addChild(self.hero)
        self.addChild(self.block1)
        self.addChild(self.block2)
        self.addChild(scoreText)
    }

    // random number
    func random () -> UInt32{
        var range = UInt32(50)...UInt32(200)
        return range.startIndex + arc4random_uniform(range.endIndex - range.startIndex + 1)
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        // When a button is clicked/touched, set 
        // a starting velocityY and the on ground switch to
        // false to signify the jump is about to happen
        if  self.onGround {
            self.velocityY = -18
            self.onGround = false
        }
        println("Start Velocity: " + self.velocityY.description)
    }
   
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        // When the touch ends, lets make sure the velocity is half the starting point
        if  self.velocityY < -9.0 {
            self.velocityY = -9.0
        }

        println("End Velocity: " + self.velocityY.description)
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        // If the ground is at the end of the width, restart the position
        if( self.runningBar.position.x <= maxBarX){
            self.runningBar.position.x = self.origRunningBarPositionX
        }
        
        // continue up the Y-axis to make hero jump
        self.velocityY += self.gravity
        self.hero.position.y -= velocityY
        
        println("Current Velocity: " + self.velocityY.description)
        println("hero position Velocity: " + self.hero.position.y.description)
        
        // Make sure hero doesn't end up past the ground
        // Because the hero basline is the top of the ground "running bar"
        if(self.hero.position.y < self.heroBaseLine){
            self.hero.position.y = self.heroBaseLine
            self.velocityY = 0.0
            self.onGround = true
        }
        
        // rotate hero by converting degrees into radiants
        var degreeRotation = CDouble(self.groundSpeed) * M_PI / 180
        
        // rotate hero
        self.hero.zRotation -= CGFloat(degreeRotation)
        
        // move the ground
        runningBar.position.x -= CGFloat(self.groundSpeed)
        
        blockRunner()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        died()
    }
    
    func died()
    {
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene
        {
            let skView = self.view as SKView!
            skView.ignoresSiblingOrder = true
            scene.size = skView.bounds.size
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
    }
    
    
    func blockRunner() {
        for(block, blockStatus) in self.blockStatuses {
            var thisBlock = self.childNodeWithName(block)!
            if blockStatus.shouldRunBlock() {
                blockStatus.timeGapForNextRun = random()
                blockStatus.currentInterval = 0
                blockStatus.isRunning = true
            }
            
            if blockStatus.isRunning {
                if thisBlock.position.x > blockMaxX {
                    thisBlock.position.x -= CGFloat(self.groundSpeed)
                }else {
                    thisBlock.position.x = self.origBlockPositionX
                    blockStatus.isRunning = false
                    self.score++
                    if ((self.score % 5) == 0) {
                        self.groundSpeed++
                    }
                    self.scoreText.text = String(self.score)
                }
            }else {
                blockStatus.currentInterval++
            }
        }
    }

}
