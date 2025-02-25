//
//  GameScene.swift
//  Flappy bird
//
//  Created by Blust, Caden on 2/25/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var bird = SKSpriteNode()
    
     override func didMove(to view: SKView) {
        
        
        
        //Gravity and physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.0);
        
        //Bird
        let BirdTexture = SKTexture(imageNamed:"Bird")
        BirdTexture.filteringMode = SKTextureFilteringMode.nearest
        
        bird = SKSpriteNode(texture: BirdTexture)
        bird.setScale(0.15)
        bird.position = CGPoint(x: self.frame.size.width * -0.3, y: self.frame.size.height * 0.6)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.allowsRotation = false
        self.addChild(bird)
        
        //Ground
        
        let groundTexture = SKTexture(imageNamed: "ground")
        let sprite = SKSpriteNode(texture: groundTexture)
        sprite.setScale(2.0)
         //sprite asset position
         sprite.position = CGPointMake(self.size.width/20, sprite.size.height - 725)
        self.addChild(sprite)
        
        
        
         let ground = SKNode()
         //hitbox position
         ground.position = CGPointMake(0, groundTexture.size().height - 635)
         ground.physicsBody = SKPhysicsBody(rectangleOf: CGSizeMake(self.frame.width, groundTexture.size().height))
         ground.physicsBody?.isDynamic = false
         self.addChild(ground)
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            _ = touch.location(in:self)
            
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 100))
            
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
