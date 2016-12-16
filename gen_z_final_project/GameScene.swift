//
//  GameScene.swift
//  gen_z_final_project
//
//  Created by Andy Chen Yang on 11/21/16.
//  Copyright © 2016 Jake Lehmann, Abrahamn Musalem, And Yang, Dingyu Wang. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var viewController: UIViewController?
    
    var starfield:SKEmitterNode!
    var player:SKSpriteNode!
    
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var dead = false
    
    var imageOfShip: String!
    
    var gameTimer:Timer!

    
    var possibleAliens = ["alien", "alien2", "alien3"]
    
    let alienCategory:UInt32 = 0x1 << 1
    let photonTorpedoCategory:UInt32 = 0x1 << 0
    let shipCategory:UInt32 = 0x1 << 0
    
    let motionManger = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
    
    override func didMove(to view: SKView) {
        
        createButton()
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: 1472)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "\(imageOfShip!)")
        player.size.height = 100
        player.size.width = 100
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        
        player.physicsBody?.categoryBitMask = shipCategory
        player.physicsBody?.contactTestBitMask = alienCategory
        player.physicsBody?.collisionBitMask = 0
        
        player.position = CGPoint(x: self.frame.size.width / 2 - 15, y: self.frame.minY + 110)
        
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 100, y: self.frame.size.height - 60)
        scoreLabel.fontName = "Copperplate"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        self.addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        
        //MARK : Accelerometer movemnt Left to Right 
        motionManger.accelerometerUpdateInterval = 0.2
        motionManger.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
            }
        }
    }
    
    func createButton() {
        let leftButton = UIImage(named: "left")
        let leftTexture = SKTexture(image: leftButton!)
        let leftSprite = SKSpriteNode(texture: leftTexture)
        
        let rightButton = UIImage(named: "right")
        let rightTexture = SKTexture(image: rightButton!)
        let rightSprite = SKSpriteNode(texture: rightTexture)
        
        let pauseButton = UIImage(named: "pause")
        let pauseTexture = SKTexture(image: pauseButton!)
        let pauseSprite = SKSpriteNode(texture: pauseTexture)
        
        let shootButton = UIImage(named: "shoot")
        let shootTexture = SKTexture(image: shootButton!)
        let shootSprite = SKSpriteNode(texture: shootTexture)
        
        // Create a simple red rectangle that's 100x44
        
        //Node(color: SKColor.red, size: CGSize(width: 100, height: 44))
        // Put it in the center of the scene
        leftSprite.position = CGPoint(x:30, y:self.frame.minY + 30);
        rightSprite.position = CGPoint(x:95, y:self.frame.minY + 30);
        pauseSprite.position = CGPoint(x:self.frame.maxX - 30, y: self.frame.height - 30);
        shootSprite.position = CGPoint(x:self.frame.maxX - 30, y: self.frame.minY + 30);
        self.addChild(leftSprite)
        self.addChild(rightSprite)
        self.addChild(pauseSprite)
        self.addChild(shootSprite)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        if touchLocation.x < 60 && touchLocation.x > 0 && touchLocation.y > self.frame.minY && touchLocation.y < self.frame.minY + 60{
            if player.position.x > self.frame.minX + 50{
                player.position.x -= 10
            }
        }
        else if touchLocation.x < 125 && touchLocation.x > 65 && touchLocation.y > self.frame.minY && touchLocation.y < self.frame.minY + 60{
            if player.position.x < self.frame.maxX - 50{
                player.position.x += 10
            }
        }
        if touchLocation.x < self.frame.maxX && touchLocation.x > self.frame.maxX - 60 && touchLocation.y > self.frame.minY && touchLocation.y < self.frame.minY + 60{
            fireTorpedo()
        }
    }
    
    
    func addAlien () {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        
        let randomAlienPosition = GKRandomDistribution(lowestValue: 0, highestValue: 414)
        let position = CGFloat(randomAlienPosition.nextInt())
        
        alien.position = CGPoint(x: position, y: self.frame.size.height + alien.size.height)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.contactTestBitMask = shipCategory
        
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        
        let animationDuration:TimeInterval = 6
        
        var actionArray = [SKAction]()
        
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -alien.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
    }
    
    func fireTorpedo() {
        self.run(SKAction.playSoundFileNamed("torpedo.wav", waitForCompletion: false))
        
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        torpedoNode.position = player.position
        torpedoNode.position.y += 5
        
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
        torpedoNode.physicsBody?.isDynamic = true
        
        torpedoNode.physicsBody?.categoryBitMask = photonTorpedoCategory
        torpedoNode.physicsBody?.contactTestBitMask = alienCategory
        torpedoNode.physicsBody?.collisionBitMask = 0
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(torpedoNode)
        
        let animationDuration:TimeInterval = 0.3
        
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        torpedoNode.run(SKAction.sequence(actionArray))
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0 {
            torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
            print("torpedo")
        }
        
        if(firstBody.categoryBitMask & alienCategory) != 0 && (secondBody.categoryBitMask & shipCategory) != 0 {
            alienDidCollideWithShip(player: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
            self.view!.window!.rootViewController!.performSegue(withIdentifier: "pauseSegue", sender: self)
            print("ship")
        }
    }
    
    // Collision with Alien
    func torpedoDidCollideWithAlien (torpedoNode:SKSpriteNode, alienNode:SKSpriteNode) {
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        torpedoNode.removeFromParent()
        alienNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        
        if torpedoNode.size == player.size{
            dead = true
        }
        
        score += 5
    }
    
    // Collision with Ship
    func alienDidCollideWithShip (player:SKSpriteNode, alienNode:SKSpriteNode) {
    
    }
    
    override func didSimulatePhysics() {
        
        player.position.x += xAcceleration * 50
        
        if player.position.x < -20 {
            player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
        }else if player.position.x > self.size.width + 20 {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if dead{
            self.view?.isPaused = true
        }
    }
    
}
