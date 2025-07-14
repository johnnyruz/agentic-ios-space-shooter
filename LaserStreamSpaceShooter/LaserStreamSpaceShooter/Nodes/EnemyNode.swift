import SpriteKit

class EnemyNode: SKSpriteNode {
    
    // MARK: - Properties
    private var health = 1
    private var points = Constants.pointsPerEnemy
    
    // MARK: - Initialization
    convenience init() {
        self.init(color: Constants.enemyColor, size: Constants.enemySize)
        setupEnemy()
    }
    
    private func setupEnemy() {
        // Set enemy properties
        name = "enemy"
        
        // Create physics body
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = Constants.enemyCategory
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = Constants.bulletCategory
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = true
        
        // Add visual effects
        addVisualEffects()
        
        // Add movement animation
        addMovementAnimation()
    }
    
    private func addVisualEffects() {
        // Add border effect
        let borderNode = SKShapeNode(rect: CGRect(x: -size.width/2, y: -size.height/2, width: size.width, height: size.height))
        borderNode.strokeColor = Constants.enemyColor.withAlphaComponent(0.8)
        borderNode.lineWidth = 2
        borderNode.fillColor = .clear
        borderNode.zPosition = 1
        addChild(borderNode)
        
        // Add pulsing effect
        let pulseAction = SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.5),
            SKAction.scale(to: 0.9, duration: 0.5)
        ])
        let repeatAction = SKAction.repeatForever(pulseAction)
        run(repeatAction)
    }
    
    private func addMovementAnimation() {
        // Add subtle rotation animation
        let rotateAction = SKAction.rotate(byAngle: CGFloat.pi / 32, duration: 0.3)
        let reverseAction = SKAction.rotate(byAngle: -CGFloat.pi / 16, duration: 0.6)
        let returnAction = SKAction.rotate(byAngle: CGFloat.pi / 32, duration: 0.3)
        let sequence = SKAction.sequence([rotateAction, reverseAction, returnAction])
        let repeatAction = SKAction.repeatForever(sequence)
        run(repeatAction)
    }
    
    // MARK: - Movement
    func startMoving() {
        // Random spawn position at top of screen
        let randomX = CGFloat.random(in: size.width/2...(Constants.screenWidth - size.width/2))
        position = CGPoint(x: randomX, y: Constants.screenHeight + size.height)
        
        // Create movement action
        let moveAction = SKAction.moveBy(x: 0, y: -(Constants.screenHeight + size.height * 2), duration: (Constants.screenHeight + size.height * 2) / Constants.enemySpeed)
        
        // Remove enemy when it goes off screen and handle life loss
        let removeAction = SKAction.run { [weak self] in
            self?.reachedBottom()
        }
        let sequence = SKAction.sequence([moveAction, removeAction])
        
        run(sequence)
    }
    
    private func reachedBottom() {
        // Enemy reached bottom, player loses a life
        GameManager.shared.loseLife()
        removeFromParent()
    }
    
    // MARK: - Combat
    func takeDamage() {
        health -= 1
        
        if health <= 0 {
            destroy()
        } else {
            // Flash effect for damage
            let flashAction = SKAction.sequence([
                SKAction.colorize(with: .white, colorBlendFactor: 0.8, duration: 0.1),
                SKAction.colorize(with: Constants.enemyColor, colorBlendFactor: 1.0, duration: 0.1)
            ])
            run(flashAction)
        }
    }
    
    func destroy() {
        // Stop all actions
        removeAllActions()
        
        // Add points to score
        GameManager.shared.addPoints(points)
        
        // Create explosion effect
        createExplosionEffect()
        
        // Play explosion sound
        AudioManager.shared.playExplosionSound()
        
        // Remove enemy after explosion
        let removeAction = SKAction.removeFromParent()
        let waitAction = SKAction.wait(forDuration: Constants.explosionDuration)
        let sequence = SKAction.sequence([waitAction, removeAction])
        run(sequence)
    }
    
    private func createExplosionEffect() {
        // Create explosion particles
        let explosionNode = SKEmitterNode()
        explosionNode.particleTexture = SKTexture(imageNamed: "spark")
        explosionNode.particleBirthRate = 200
        explosionNode.particleLifetime = 0.5
        explosionNode.particleScale = 0.2
        explosionNode.particleScaleSpeed = -0.3
        explosionNode.particleColor = Constants.explosionColor
        explosionNode.particleColorBlendFactor = 1.0
        explosionNode.particleSpeed = 100
        explosionNode.particleSpeedRange = 50
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
        
        // Screen shake effect
        createScreenShakeEffect()
    }
    
    private func createScreenShakeEffect() {
        guard let scene = scene else { return }
        
        let shakeAmount: CGFloat = 5.0
        let shakeDuration: TimeInterval = 0.2
        
        let shakeAction = SKAction.sequence([
            SKAction.moveBy(x: shakeAmount, y: 0, duration: shakeDuration / 8),
            SKAction.moveBy(x: -shakeAmount * 2, y: 0, duration: shakeDuration / 4),
            SKAction.moveBy(x: shakeAmount * 2, y: 0, duration: shakeDuration / 4),
            SKAction.moveBy(x: -shakeAmount, y: 0, duration: shakeDuration / 8)
        ])
        
        scene.run(shakeAction)
    }
    
    // MARK: - Getters
    func getHealth() -> Int {
        return health
    }
    
    func getPoints() -> Int {
        return points
    }
    
    // MARK: - Cleanup
    override func removeFromParent() {
        removeAllActions()
        super.removeFromParent()
    }
}