import SpriteKit

class GunNode: SKSpriteNode {
    
    // MARK: - Properties
    private var lastFireTime: TimeInterval = 0
    private var isActive = false
    
    // MARK: - Initialization
    convenience init() {
        self.init(color: Constants.gunColor, size: Constants.gunSize)
        setupGun()
    }
    
    private func setupGun() {
        // Set gun properties
        name = "gun"
        
        // Position gun at bottom of screen
        position = CGPoint(x: Constants.screenWidth / 2, y: Constants.gunBottomMargin)
        
        // Create physics body
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = Constants.gunCategory
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = 0
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        
        // Add visual effects
        addVisualEffects()
        
        // Start firing
        isActive = true
    }
    
    private func addVisualEffects() {
        // Add gun barrel effect
        let barrel = SKSpriteNode(color: Constants.gunColor.withAlphaComponent(0.8), size: CGSize(width: 8, height: 15))
        barrel.position = CGPoint(x: 0, y: size.height / 2)
        barrel.zPosition = 1
        addChild(barrel)
        
        // Add base effect
        let base = SKSpriteNode(color: Constants.gunColor.withAlphaComponent(0.6), size: CGSize(width: size.width * 1.2, height: 10))
        base.position = CGPoint(x: 0, y: -size.height / 2)
        base.zPosition = 1
        addChild(base)
        
        // Add glow effect
        let glowNode = SKSpriteNode(color: Constants.gunColor.withAlphaComponent(0.3), size: CGSize(width: size.width * 1.5, height: size.height * 1.5))
        glowNode.blendMode = .add
        glowNode.zPosition = -1
        addChild(glowNode)
        
        // Animate glow
        let pulseAction = SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.2),
            SKAction.scale(to: 0.9, duration: 0.2)
        ])
        let repeatAction = SKAction.repeatForever(pulseAction)
        glowNode.run(repeatAction)
    }
    
    // MARK: - Movement
    func updatePosition(to newPosition: CGPoint) {
        let clampedX = max(size.width / 2, min(newPosition.x, Constants.screenWidth - size.width / 2))
        let targetPosition = CGPoint(x: clampedX, y: position.y)
        
        // Smooth movement
        let moveAction = SKAction.move(to: targetPosition, duration: 0.1)
        run(moveAction)
    }
    
    func moveToPosition(_ newPosition: CGPoint) {
        let clampedX = max(size.width / 2, min(newPosition.x, Constants.screenWidth - size.width / 2))
        position = CGPoint(x: clampedX, y: position.y)
    }
    
    // MARK: - Firing
    func attemptToFire(currentTime: TimeInterval) -> BulletNode? {
        guard isActive else { return nil }
        guard currentTime - lastFireTime >= Constants.bulletFireRate else { return nil }
        
        lastFireTime = currentTime
        
        // Create bullet
        let bullet = BulletNode()
        
        // Set bullet firing position
        let firePosition = CGPoint(x: position.x, y: position.y + size.height / 2)
        bullet.fire(from: firePosition)
        
        // Play bullet sound
        AudioManager.shared.playBulletSound()
        
        // Add firing effect
        addFiringEffect()
        
        return bullet
    }
    
    private func addFiringEffect() {
        // Create muzzle flash effect
        let flashNode = SKSpriteNode(color: .white, size: CGSize(width: 12, height: 8))
        flashNode.position = CGPoint(x: 0, y: size.height / 2)
        flashNode.zPosition = 5
        addChild(flashNode)
        
        // Animate muzzle flash
        let scaleAction = SKAction.sequence([
            SKAction.scale(to: 1.5, duration: 0.05),
            SKAction.scale(to: 0, duration: 0.05)
        ])
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([scaleAction, removeAction])
        flashNode.run(sequence)
        
        // Add recoil effect
        let recoilAction = SKAction.sequence([
            SKAction.moveBy(x: 0, y: -3, duration: 0.05),
            SKAction.moveBy(x: 0, y: 3, duration: 0.05)
        ])
        run(recoilAction)
    }
    
    // MARK: - Control
    func activate() {
        isActive = true
        alpha = 1.0
    }
    
    func deactivate() {
        isActive = false
        alpha = 0.5
    }
    
    func reset() {
        position = CGPoint(x: Constants.screenWidth / 2, y: Constants.gunBottomMargin)
        lastFireTime = 0
        activate()
    }
    
    // MARK: - Getters
    func isGunActive() -> Bool {
        return isActive
    }
    
    func getFirePosition() -> CGPoint {
        return CGPoint(x: position.x, y: position.y + size.height / 2)
    }
    
    // MARK: - Cleanup
    override func removeFromParent() {
        removeAllActions()
        super.removeFromParent()
    }
}