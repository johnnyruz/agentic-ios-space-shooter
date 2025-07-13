import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Game Objects
    private var gunNode: GunNode!
    private var bullets: [BulletNode] = []
    private var enemies: [EnemyNode] = []
    
    // MARK: - UI Elements
    private var scoreLabel: SKLabelNode!
    private var livesLabel: SKLabelNode!
    private var backgroundNode: SKSpriteNode!
    
    // MARK: - Game State
    private var lastUpdateTime: TimeInterval = 0
    private var lastEnemySpawnTime: TimeInterval = 0
    private var isGameActive = false
    
    // MARK: - Touch Handling
    private var lastTouchPosition: CGPoint?
    
    // MARK: - Scene Setup
    override func didMove(to view: SKView) {
        setupScene()
        setupPhysics()
        setupBackground()
        setupGameObjects()
        setupUI()
        startGame()
    }
    
    private func setupScene() {
        backgroundColor = Constants.backgroundColor
        size = CGSize(width: Constants.screenWidth, height: Constants.screenHeight)
        scaleMode = .aspectFill
    }
    
    private func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    private func setupBackground() {
        // Create scrolling space background
        backgroundNode = SKSpriteNode(color: .black, size: size)
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.zPosition = -10
        addChild(backgroundNode)
        
        // Add scrolling stars
        createScrollingStarField()
    }
    
    private func createScrollingStarField() {
        for _ in 0..<150 {
            let star = SKSpriteNode(color: .white, size: CGSize(width: 1, height: 1))
            star.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            )
            star.alpha = CGFloat.random(in: 0.3...1.0)
            star.zPosition = -5
            
            // Add scrolling animation
            let moveAction = SKAction.moveBy(x: 0, y: -size.height - 100, duration: Double.random(in: 3.0...8.0))
            let resetAction = SKAction.run {
                star.position = CGPoint(x: CGFloat.random(in: 0...self.size.width), y: self.size.height + 50)
            }
            let sequence = SKAction.sequence([moveAction, resetAction])
            let repeatAction = SKAction.repeatForever(sequence)
            star.run(repeatAction)
            
            addChild(star)
        }
    }
    
    private func setupGameObjects() {
        // Create gun
        gunNode = GunNode()
        addChild(gunNode)
    }
    
    private func setupUI() {
        // Score Label
        scoreLabel = SKLabelNode(text: "SCORE: 0")
        scoreLabel.fontName = "Helvetica-Bold"
        scoreLabel.fontSize = Constants.fontSize
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: Constants.hudMargin, y: size.height - Constants.hudMargin - scoreLabel.frame.height)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.zPosition = 100
        addChild(scoreLabel)
        
        // Lives Label
        livesLabel = SKLabelNode(text: "LIVES: \(GameManager.shared.getLives())")
        livesLabel.fontName = "Helvetica-Bold"
        livesLabel.fontSize = Constants.fontSize
        livesLabel.fontColor = .white
        livesLabel.position = CGPoint(x: size.width - Constants.hudMargin, y: size.height - Constants.hudMargin - livesLabel.frame.height)
        livesLabel.horizontalAlignmentMode = .right
        livesLabel.zPosition = 100
        addChild(livesLabel)
    }
    
    private func startGame() {
        GameManager.shared.startNewGame()
        isGameActive = true
        AudioManager.shared.playBackgroundMusic()
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        lastTouchPosition = touch.location(in: self)
        
        if let position = lastTouchPosition {
            gunNode.moveToPosition(position)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        lastTouchPosition = touch.location(in: self)
        
        if let position = lastTouchPosition {
            gunNode.updatePosition(to: position)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    // MARK: - Game Loop
    override func update(_ currentTime: TimeInterval) {
        guard isGameActive else { return }
        
        // Initialize last update time
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        // Update game objects
        updateBullets(currentTime: currentTime)
        updateEnemies(currentTime: currentTime)
        updateUI()
        
        // Check game over condition
        checkGameOver()
        
        // Clean up off-screen objects
        cleanupObjects()
    }
    
    private func updateBullets(currentTime: TimeInterval) {
        // Fire bullets
        if let bullet = gunNode.attemptToFire(currentTime: currentTime) {
            bullets.append(bullet)
            addChild(bullet)
        }
        
        // Remove bullets that are off-screen
        bullets.removeAll { bullet in
            if bullet.position.y > size.height + 100 || bullet.parent == nil {
                bullet.removeFromParent()
                return true
            }
            return false
        }
        
        // Limit bullets on screen
        if bullets.count > Constants.maxBulletsOnScreen {
            let bulletsToRemove = bullets.count - Constants.maxBulletsOnScreen
            for i in 0..<bulletsToRemove {
                bullets[i].removeFromParent()
            }
            bullets.removeFirst(bulletsToRemove)
        }
    }
    
    private func updateEnemies(currentTime: TimeInterval) {
        // Spawn enemies
        if currentTime - lastEnemySpawnTime > GameManager.shared.getEnemySpawnRate() {
            spawnEnemy()
            lastEnemySpawnTime = currentTime
        }
        
        // Remove enemies that are off-screen or destroyed
        enemies.removeAll { enemy in
            if enemy.position.y < -100 || enemy.parent == nil {
                enemy.removeFromParent()
                return true
            }
            return false
        }
        
        // Limit enemies on screen
        if enemies.count > Constants.maxEnemiesOnScreen {
            let enemiesToRemove = enemies.count - Constants.maxEnemiesOnScreen
            for i in 0..<enemiesToRemove {
                enemies[i].removeFromParent()
            }
            enemies.removeFirst(enemiesToRemove)
        }
    }
    
    private func spawnEnemy() {
        let enemy = EnemyNode()
        enemy.startMoving()
        enemies.append(enemy)
        addChild(enemy)
    }
    
    private func updateUI() {
        scoreLabel.text = "SCORE: \(GameManager.shared.getScore())"
        livesLabel.text = "LIVES: \(GameManager.shared.getLives())"
    }
    
    private func checkGameOver() {
        if GameManager.shared.isGameOver() {
            gameOver()
        }
    }
    
    private func cleanupObjects() {
        // Clean up bullets
        bullets = bullets.filter { $0.parent != nil }
        
        // Clean up enemies
        enemies = enemies.filter { $0.parent != nil }
    }
    
    // MARK: - Physics Contact
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        // Check bullet-enemy collision
        if (bodyA.categoryBitMask == Constants.bulletCategory && bodyB.categoryBitMask == Constants.enemyCategory) ||
           (bodyA.categoryBitMask == Constants.enemyCategory && bodyB.categoryBitMask == Constants.bulletCategory) {
            
            var bullet: BulletNode?
            var enemy: EnemyNode?
            
            if bodyA.categoryBitMask == Constants.bulletCategory {
                bullet = bodyA.node as? BulletNode
                enemy = bodyB.node as? EnemyNode
            } else {
                bullet = bodyB.node as? BulletNode
                enemy = bodyA.node as? EnemyNode
            }
            
            handleBulletEnemyCollision(bullet: bullet, enemy: enemy)
        }
    }
    
    private func handleBulletEnemyCollision(bullet: BulletNode?, enemy: EnemyNode?) {
        guard let bullet = bullet, let enemy = enemy else { return }
        
        // Remove bullet from array
        if let bulletIndex = bullets.firstIndex(of: bullet) {
            bullets.remove(at: bulletIndex)
        }
        
        // Remove enemy from array
        if let enemyIndex = enemies.firstIndex(of: enemy) {
            enemies.remove(at: enemyIndex)
        }
        
        // Destroy bullet and enemy
        bullet.explode()
        enemy.takeDamage()
    }
    
    // MARK: - Game Over
    private func gameOver() {
        isGameActive = false
        
        // Stop all actions
        removeAllActions()
        
        // Stop background music
        AudioManager.shared.stopBackgroundMusic()
        
        // Transition to game over scene
        let gameOverScene = GameOverScene(score: GameManager.shared.getScore())
        gameOverScene.scaleMode = .aspectFill
        
        let transition = SKTransition.fade(withDuration: Constants.sceneTransitionDuration)
        view?.presentScene(gameOverScene, transition: transition)
    }
    
    // MARK: - Scene Lifecycle
    override func willMove(from view: SKView) {
        // Clean up when leaving scene
        removeAllActions()
        bullets.removeAll()
        enemies.removeAll()
    }
    
    // MARK: - Pause/Resume
    func pauseGame() {
        isGameActive = false
        isPaused = true
        AudioManager.shared.pauseBackgroundMusic()
    }
    
    func resumeGame() {
        isGameActive = true
        isPaused = false
        AudioManager.shared.resumeBackgroundMusic()
    }
}