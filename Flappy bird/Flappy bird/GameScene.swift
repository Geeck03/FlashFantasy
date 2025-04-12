//
//  GameScene.swift
//  Flappy bird
//
//  Created by Blust, Caden on 2/25/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var coinCollected = false
    var score = 0
    var coins = [SKSpriteNode]()
    var bird = SKSpriteNode()
    var pipeUpTexture = SKTexture()
    var pipeDownTexture = SKTexture()
    var pipesMoveAndRemove = SKAction()
    var isGameOver = false
    var gameOverLabel: SKLabelNode?
    var scoreLabel: SKLabelNode!

    
    let birdCategory: UInt32 = 0x1 << 0
    let coinCategory: UInt32 = 0x1 << 1
    let pipeCategory: UInt32 = 0x1 << 2

    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVectorMake(0.0, -9.8)
        physicsWorld.contactDelegate = self
        
        setupScene()
        startSpawningPipes()
    }
    
    func setupScene() {
        removeAllChildren()
        removeAllActions()
        score = 0
        coins.removeAll()
        isGameOver = false
        self.isPaused = false
        
        // Background
        let background = SKSpriteNode(imageNamed: "Castle")
        background.alpha = 1.0
        background.zPosition = -100
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.addChild(background)
        
        // Bird
        let birdTexture = SKTexture(imageNamed: "Bird")
        birdTexture.filteringMode = .nearest
        bird = SKSpriteNode(texture: birdTexture)
        bird.setScale(0.12)
        bird.position = CGPoint(x: self.frame.size.width * 0.25, y: self.frame.size.height * 0.6)
        bird.zPosition = 1
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.contactTestBitMask = coinCategory | pipeCategory
        self.addChild(bird)
        
        // Score Label
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 22
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: self.frame.maxX - 40, y: self.frame.maxY - 60)
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.zPosition = 10
        scoreLabel.text = "Score: \(score)"
        self.addChild(scoreLabel)

        
        // Ground
        let groundTexture = SKTexture(imageNamed: "ground")
        let groundSprite = SKSpriteNode(texture: groundTexture)
        groundSprite.setScale(2.0)
        groundSprite.position = CGPoint(x: self.size.width / 2, y: groundSprite.size.height / 2.0)
        self.addChild(groundSprite)

        // Collision node for ground
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: groundTexture.size().height)
        ground.zPosition = 1
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: groundTexture.size().height))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = pipeCategory
        ground.physicsBody?.contactTestBitMask = birdCategory
        self.addChild(ground)
        
        // Pipe textures
        pipeUpTexture = SKTexture(imageNamed: "PipeUp")
        pipeDownTexture = SKTexture(imageNamed: "PipeDown")
        
        let distanceToMove = CGFloat(self.frame.width + 2.0 * pipeUpTexture.size().width)
        let movePipes = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        pipesMoveAndRemove = SKAction.sequence([movePipes, removePipes])
    }
    
    func startSpawningPipes() {
        let spawn = SKAction.run { self.spawnPipes() }
        let delay = SKAction.wait(forDuration: 3.5)
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatForever(spawnThenDelay)
        self.run(spawnThenDelayForever, withKey: "pipeSpawning")
    }
    
    func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPoint(x: self.frame.size.width + pipeUpTexture.size().width * 0.5, y: 0)
        
        let pipeScale: CGFloat = 0.4
        let centerY = self.frame.size.height / 2 - 30
        let randomOffset = CGFloat(arc4random_uniform(200))
        let pipeGap = 245.0

        let pipeDown = SKSpriteNode(texture: pipeDownTexture)
        pipeDown.position = CGPoint(x: 0.0, y: centerY - pipeGap + randomOffset)
        pipeDown.zPosition = -1
        pipeDown.setScale(pipeScale)
        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeDown.size.width * pipeScale * 0.6, height: pipeDown.size.height * pipeScale))
        pipeDown.physicsBody?.isDynamic = false
        pipeDown.physicsBody?.categoryBitMask = pipeCategory
        pipeDown.physicsBody?.contactTestBitMask = birdCategory
        
        let pipeUp = SKSpriteNode(texture: pipeUpTexture)
        pipeUp.position = CGPoint(x: 0.0, y: centerY + pipeGap + randomOffset)
        pipeUp.zPosition = -1
        pipeUp.setScale(pipeScale)
        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeUp.size.width * pipeScale * 0.6, height: pipeUp.size.height * pipeScale))
        pipeUp.physicsBody?.isDynamic = false
        pipeUp.physicsBody?.categoryBitMask = pipeCategory
        pipeUp.physicsBody?.contactTestBitMask = birdCategory
        
        pipePair.addChild(pipeDown)
        pipePair.addChild(pipeUp)
        pipePair.run(pipesMoveAndRemove)
        self.addChild(pipePair)
        
        spawnCoin(betweenY: centerY + randomOffset, gapHeight: pipeGap)
    }
    
    func spawnCoin(betweenY: CGFloat, gapHeight: CGFloat) {
        let coinTexture = SKTexture(imageNamed: "Coin")
        let coin = SKSpriteNode(texture: coinTexture)
        coin.setScale(0.01)
        
        let coinX = self.frame.width + coin.size.width / 2
        let coinY = betweenY - gapHeight / 2 + CGFloat.random(in: 0...gapHeight)
        
        coin.position = CGPoint(x: coinX, y: coinY)
        coin.zPosition = 0
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.size.width / 2)
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.categoryBitMask = coinCategory
        coin.physicsBody?.contactTestBitMask = birdCategory
        coin.physicsBody?.collisionBitMask = 0
        
        coins.append(coin)
        self.addChild(coin)
        
        let moveCoin = SKAction.moveBy(x: -self.frame.width - coin.size.width, y: 0.0, duration: TimeInterval(0.01 * (self.frame.width + coin.size.width)))
        let removeCoin = SKAction.removeFromParent()
        let coinMoveAndRemove = SKAction.sequence([moveCoin, removeCoin])
        coin.run(coinMoveAndRemove)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA.categoryBitMask
        let contactB = contact.bodyB.categoryBitMask

        if (contactA == birdCategory && contactB == coinCategory) || (contactA == coinCategory && contactB == birdCategory) {
            let coinNode = (contactA == coinCategory ? contact.bodyA.node : contact.bodyB.node) as? SKSpriteNode
            if let coin = coinNode {
                handleCoinCollision(coin)
            }
        }

        if (contactA == birdCategory && contactB == pipeCategory) || (contactA == pipeCategory && contactB == birdCategory) {
            gameOver()
        }
    }
    
    func handleCoinCollision(_ coin: SKSpriteNode) {
        coin.removeFromParent()
        coins.removeAll { $0 == coin }
        score += 1
        scoreLabel.text = "Score: \(score)"
        coinCollected = true
    }

    
    func gameOver() {
        if isGameOver { return }
        isGameOver = true
        self.removeAction(forKey: "pipeSpawning")
        self.isPaused = true
        
        gameOverLabel = SKLabelNode(text: "Game Over - Tap Screen to Restart")
        gameOverLabel?.fontName = "Chalkduster"
        gameOverLabel?.fontSize = 18
        gameOverLabel?.fontColor = .red
        gameOverLabel?.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        gameOverLabel?.zPosition = 10
        if let label = gameOverLabel {
            self.addChild(label)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
            gameOverLabel?.removeFromParent()
            setupScene()
            startSpawningPipes()
            return
        }
        bird.physicsBody?.velocity = CGVectorMake(0, 0)
        bird.physicsBody?.applyImpulse(CGVectorMake(0, 85))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !coinCollected {
            for coin in coins {
                if bird.frame.intersects(coin.frame) {
                    handleCoinCollision(coin)
                    break
                }
            }
        }
        coinCollected = false
    }
}
