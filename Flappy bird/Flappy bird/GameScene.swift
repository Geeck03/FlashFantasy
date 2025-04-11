//
//  GameScene.swift
//  Flappy bird
//
//  Created by Blust, Caden on 2/25/25.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let bird: UInt32 = 0x1 << 0
    static let pipe: UInt32 = 0x1 << 1
    static let ground: UInt32 = 0x1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    
    var bird = SKSpriteNode()
    var pipeUpTexture = SKTexture()
    var pipeDownTexture = SKTexture()
    var pipesMoveAndRemove = SKAction()
    var gameOver = false
    var gameOverLabel: SKLabelNode?
    let ground = SKNode() //var


    
     override func didMove(to view: SKView) { //didMoveToView
        
        //Gravity and physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -9.8); //Gravity number can determine difficulty
        
        //Bird
        let BirdTexture = SKTexture(imageNamed:"Bird")
        BirdTexture.filteringMode = SKTextureFilteringMode.nearest
        
        bird = SKSpriteNode(texture: BirdTexture)
        bird.setScale(0.15)
        bird.position = CGPoint(x: self.frame.size.width * 0.25, y: self.frame.size.height * 0.6)//0.35
        bird.zPosition = 1 //make sure bird is at the top of the graph
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.allowsRotation = false
         
        self.addChild(bird)
        
        //Ground
        
         let groundTexture = SKTexture(imageNamed: "ground") //var
         let sprite = SKSpriteNode(texture: groundTexture) //var
        sprite.setScale(2.0)
         //sprite asset position
         sprite.position = CGPointMake(self.size.width/2, sprite.size.height/2.0)
        self.addChild(sprite)
        
         self.physicsWorld.contactDelegate = self

         bird.physicsBody?.categoryBitMask = PhysicsCategory.bird
         bird.physicsBody?.contactTestBitMask = PhysicsCategory.pipe | PhysicsCategory.ground
         bird.physicsBody?.collisionBitMask = PhysicsCategory.pipe | PhysicsCategory.ground

         ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
         ground.physicsBody?.contactTestBitMask = PhysicsCategory.bird
         ground.physicsBody?.collisionBitMask = 0

         
        //Pipes
        //Create the Pipes
         pipeUpTexture = SKTexture(imageNamed:"PipeUp")
         pipeDownTexture = SKTexture(imageNamed:"PipeDown")
         
         //Pipes Movement
         let distanceToMove = CGFloat(self.frame.width + 2.0 * pipeUpTexture.size().width)
         let movePipes = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(0.005 * distanceToMove)) //Smaller the duration, faster pipes move
         let removePipes = SKAction.removeFromParent()
         pipesMoveAndRemove = SKAction.sequence([movePipes, removePipes])
         
         //Spawn Pipes Continously
         let spawn = SKAction.run({() in self.spawnPipes()})
         let delay = SKAction.wait(forDuration: TimeInterval(2.0)) //Determine the frequency pipes appearance
         let spawnThenDelay = SKAction.sequence([spawn,delay])
         let spawnThenDelayForever = SKAction.repeatForever(spawnThenDelay)
         self.run(spawnThenDelayForever)
         
         
         //hitbox position
         ground.position = CGPointMake(0, groundTexture.size().height)
         ground.zPosition = 1 // Above background
         ground.physicsBody = SKPhysicsBody(rectangleOf: CGSizeMake(self.frame.size.width,  groundTexture.size().height))
         ground.physicsBody?.isDynamic = false
         self.addChild(ground)
         
         //Background
         let background = SKSpriteNode(imageNamed: "Castle")
         background.alpha = 1.0
         background.zPosition = -100
         background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
         background.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
         self.addChild(background)
         
         if let testImage = UIImage(named: "Castle") {
             print("Image loaded successfully!")
         } else {
             print("Image failed to load.")
         }

    }
    
    func spawnPipes() {
        let pipePair = SKNode()
        // determine when do pipes appear
        pipePair.position = CGPointMake(self.frame.size.width + pipeUpTexture.size().width * 0.5, 0)
        
        let height = UInt32(self.frame.size.height/4)
        _ = arc4random() % height + height
        
        let pipeDown = SKSpriteNode(texture: pipeDownTexture)
        let pipeUp = SKSpriteNode(texture: pipeUpTexture)
        
        let pipeScale: CGFloat = 0.4
        let centerY = self.frame.size.height / 2 + 30
        let randomOffset = CGFloat(arc4random_uniform(200)) // random y position of pipepair
        let pipeGap = 245.0 //Control the vertical gap between a pipe pair (could determine difficulty)

        pipeUp.position = CGPoint(x: 0.0, y: centerY + pipeGap + randomOffset)
        pipeUp.zPosition = -1

        pipeDown.position = CGPoint(x: 0.0, y: centerY - pipeGap + randomOffset)
        pipeDown.zPosition = -1
        
        pipeDown.setScale(pipeScale)
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeDown.size.width * pipeScale * 0.6, height: pipeDown.size.height * pipeScale * 1.25))
        pipeDown.physicsBody?.isDynamic = false
        pipePair.addChild(pipeDown)
        
        pipeUp.setScale(pipeScale)
        
        //Customize the physical volume by visual scale
        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeUp.size.width * pipeScale * 0.6, height: pipeUp.size.height * pipeScale * 1.25))
        pipeUp.physicsBody?.isDynamic = false
        
        pipeUp.size = CGSize(width: pipeUp.size.width, height: pipeUp.size.height * 1.25)
        pipeDown.size = CGSize(width: pipeDown.size.width, height: pipeDown.size.height * 1.25)
        pipePair.addChild(pipeUp)
        
        pipePair.run(pipesMoveAndRemove)
        self.addChild(pipePair)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if gameOver { return }

        gameOver = true
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bird.physicsBody?.isDynamic = false

        self.removeAction(forKey: "pipeSpawn")

        self.enumerateChildNodes(withName: "pipePair") { node, _ in
            node.removeAllActions()
        }

        showGameOverLabel()

        self.isPaused = true
    }


    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isPaused = false

        if gameOver {
            restartGame()
            return
        }

        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 150))
    }

    func showGameOverLabel() {
        gameOverLabel = SKLabelNode(text: "Game Over - Tap to Restart")
        gameOverLabel?.fontName = "Chalkduster"
        gameOverLabel?.fontSize = 22
        gameOverLabel?.fontColor = .red
        gameOverLabel?.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        gameOverLabel?.zPosition = 10
        if let label = gameOverLabel {
            self.addChild(label)
        }
    }

    func restartGame() {
        self.removeAllChildren()
        self.removeAllActions()
        gameOver = false
        gameOverLabel = nil
        didMove(to: self.view!)
    }

    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
