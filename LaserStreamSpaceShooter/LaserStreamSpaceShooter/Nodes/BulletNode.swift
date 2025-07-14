import SpriteKit

class BulletNode: SKSpriteNode {
    
    // MARK: - Initialization
    convenience init() {
        self.init(color: Constants.bulletColor, size: Constants.bulletSize)
        setupBullet()
    }
    
    private func setupBullet() {
        // Set bullet properties
        name = "bullet"
        
        // Create physics body
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = Constants.bulletCategory
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = Constants.enemyCategory
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = true
        
        // Add glow effect
        addGlowEffect()
    }
    
    private func addGlowEffect() {
        // Create glow effect
        let glowNode = SKSpriteNode(color: Constants.bulletColor.withAlphaComponent(0.5), size: CGSize(width: size.width * 2, height: size.height * 2))
        glowNode.blendMode = .add
        glowNode.zPosition = -1
        addChild(glowNode)
        
        // Animate glow
        let pulseAction = SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.1),
            SKAction.scale(to: 0.8, duration: 0.1)
        ])
        let repeatAction = SKAction.repeatForever(pulseAction)
        glowNode.run(repeatAction)
    }
    
    // MARK: - Movement
    func fire(from startPosition: CGPoint) {
        position = startPosition
        
        // Create movement action
        let moveAction = SKAction.moveBy(x: 0, y: Constants.screenHeight + size.height, duration: (Constants.screenHeight + size.height) / Constants.bulletSpeed)
        
        // Remove bullet when it goes off screen
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveAction, removeAction])
        
        run(sequence)
    }
    
    // MARK: - Collision Handling
    func explode() {
        // Stop all actions
        removeAllActions()
        
        // Create explosion effect
        createExplosionEffect()
        
        // Remove bullet after explosion
        let removeAction = SKAction.removeFromParent()
        let waitAction = SKAction.wait(forDuration: Constants.explosionDuration)
        let sequence = SKAction.sequence([waitAction, removeAction])
        run(sequence)
    }
    
    private func createExplosionEffect() {
        // Create explosion particles
        let explosionNode = SKEmitterNode()
        explosionNode.particleTexture = SKTexture(imageNamed: "spark")
        explosionNode.particleBirthRate = 100
        explosionNode.particleLifetime = 0.3
        explosionNode.particleScale = 0.1
        explosionNode.particleScaleSpeed = -0.2
        explosionNode.particleColor = Constants.explosionColor
        explosionNode.particleColorBlendFactor = 1.0
        explosionNode.particleSpeed = 50
        explosionNode.particleSpeedRange = 30
        explosionNode.emissionAngle = 0
        explosionNode.emissionAngleRange = CGFloat.pi * 2
        explosionNode.position = position
        explosionNode.zPosition = 10
        
        parent?.addChild(explosionNode)
        
        // Remove explosion after duration
        let removeExplosionAction = SKAction.sequence([
            SKAction.wait(forDuration: Constants.explosionDuration),
            SKAction.removeFromParent()
        ])
        explosionNode.run(removeExplosionAction)
    }
    
    // MARK: - Cleanup
    override func removeFromParent() {
        removeAllActions()
        super.removeFromParent()
    }
}