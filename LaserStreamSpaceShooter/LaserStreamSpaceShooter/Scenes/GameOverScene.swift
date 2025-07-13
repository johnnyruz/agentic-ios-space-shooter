import SpriteKit

class GameOverScene: SKScene {
    
    // MARK: - Properties
    private var finalScore: Int = 0
    private var isNewHighScore: Bool = false
    
    // MARK: - UI Elements
    private var gameOverLabel: SKLabelNode!
    private var scoreLabel: SKLabelNode!
    private var highScoreLabel: SKLabelNode!
    private var newHighScoreLabel: SKLabelNode!
    private var playAgainButton: SKLabelNode!
    private var menuButton: SKLabelNode!
    private var backgroundNode: SKSpriteNode!
    
    // MARK: - Initialization
    convenience init(score: Int) {
        self.init()
        self.finalScore = score
        self.isNewHighScore = score > GameManager.shared.highScore
    }
    
    // MARK: - Scene Setup
    override func didMove(to view: SKView) {
        setupScene()
        setupBackground()
        setupUI()
        playGameOverSound()
    }
    
    private func setupScene() {
        backgroundColor = Constants.backgroundColor
        size = CGSize(width: Constants.screenWidth, height: Constants.screenHeight)
        scaleMode = .aspectFill
    }
    
    private func setupBackground() {
        // Create dark background
        backgroundNode = SKSpriteNode(color: .black, size: size)
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.zPosition = -10
        addChild(backgroundNode)
        
        // Add fading stars
        createFadingStarField()
    }
    
    private func createFadingStarField() {
        for _ in 0..<50 {
            let star = SKSpriteNode(color: .white, size: CGSize(width: 1, height: 1))
            star.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            )
            star.alpha = 0.3
            star.zPosition = -5
            
            // Add slow fading animation
            let fadeOut = SKAction.fadeAlpha(to: 0.1, duration: Double.random(in: 2.0...4.0))
            let fadeIn = SKAction.fadeAlpha(to: 0.3, duration: Double.random(in: 2.0...4.0))
            let fade = SKAction.sequence([fadeOut, fadeIn])
            let repeatFade = SKAction.repeatForever(fade)
            star.run(repeatFade)
            
            addChild(star)
        }
    }
    
    private func setupUI() {
        // Game Over Title
        gameOverLabel = SKLabelNode(text: "GAME OVER")
        gameOverLabel.fontName = "Helvetica-Bold"
        gameOverLabel.fontSize = Constants.titleFontSize
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.75)
        gameOverLabel.zPosition = 1
        addChild(gameOverLabel)
        
        // Final Score
        scoreLabel = SKLabelNode(text: "FINAL SCORE: \(finalScore)")
        scoreLabel.fontName = "Helvetica-Bold"
        scoreLabel.fontSize = Constants.buttonFontSize
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.6)
        scoreLabel.zPosition = 1
        addChild(scoreLabel)
        
        // High Score Display
        let currentHighScore = GameManager.shared.highScore
        highScoreLabel = SKLabelNode(text: "HIGH SCORE: \(currentHighScore)")
        highScoreLabel.fontName = "Helvetica-Bold"
        highScoreLabel.fontSize = Constants.fontSize
        highScoreLabel.fontColor = .yellow
        highScoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.5)
        highScoreLabel.zPosition = 1
        addChild(highScoreLabel)
        
        // New High Score Notification
        if isNewHighScore {
            newHighScoreLabel = SKLabelNode(text: "NEW HIGH SCORE!")
            newHighScoreLabel.fontName = "Helvetica-Bold"
            newHighScoreLabel.fontSize = Constants.fontSize
            newHighScoreLabel.fontColor = .green
            newHighScoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.45)
            newHighScoreLabel.zPosition = 1
            addChild(newHighScoreLabel)
            
            // Add pulsing animation to new high score
            let pulseAction = SKAction.sequence([
                SKAction.scale(to: 1.2, duration: 0.5),
                SKAction.scale(to: 1.0, duration: 0.5)
            ])
            let repeatPulse = SKAction.repeatForever(pulseAction)
            newHighScoreLabel.run(repeatPulse)
        }
        
        // Play Again Button
        playAgainButton = SKLabelNode(text: "PLAY AGAIN")
        playAgainButton.fontName = "Helvetica-Bold"
        playAgainButton.fontSize = Constants.buttonFontSize
        playAgainButton.fontColor = .green
        playAgainButton.position = CGPoint(x: size.width / 2, y: size.height * 0.35)
        playAgainButton.name = "playAgainButton"
        playAgainButton.zPosition = 1
        addChild(playAgainButton)
        
        // Menu Button
        menuButton = SKLabelNode(text: "MAIN MENU")
        menuButton.fontName = "Helvetica-Bold"
        menuButton.fontSize = Constants.buttonFontSize
        menuButton.fontColor = .cyan
        menuButton.position = CGPoint(x: size.width / 2, y: size.height * 0.25)
        menuButton.name = "menuButton"
        menuButton.zPosition = 1
        addChild(menuButton)
        
        // Add animations
        addUIAnimations()
    }
    
    private func addUIAnimations() {
        // Game Over label animation
        let gameOverScale = SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.8),
            SKAction.scale(to: 1.0, duration: 0.8)
        ])
        let repeatGameOverScale = SKAction.repeatForever(gameOverScale)
        gameOverLabel.run(repeatGameOverScale)
        
        // Play Again button animation
        let playAgainPulse = SKAction.sequence([
            SKAction.scale(to: 1.05, duration: 0.6),
            SKAction.scale(to: 1.0, duration: 0.6)
        ])
        let repeatPlayAgainPulse = SKAction.repeatForever(playAgainPulse)
        playAgainButton.run(repeatPlayAgainPulse)
        
        // Menu button animation
        let menuPulse = SKAction.sequence([
            SKAction.scale(to: 1.05, duration: 0.7),
            SKAction.scale(to: 1.0, duration: 0.7)
        ])
        let repeatMenuPulse = SKAction.repeatForever(menuPulse)
        menuButton.run(repeatMenuPulse)
    }
    
    private func playGameOverSound() {
        AudioManager.shared.playGameOverSound()
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        handleTouch(on: touchedNode)
    }
    
    private func handleTouch(on node: SKNode) {
        guard let nodeName = node.name else { return }
        
        switch nodeName {
        case "playAgainButton":
            playAgain()
        case "menuButton":
            returnToMenu()
        default:
            break
        }
    }
    
    private func playAgain() {
        // Add button press effect
        let scaleDown = SKAction.scale(to: 0.9, duration: 0.1)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
        let scaleSequence = SKAction.sequence([scaleDown, scaleUp])
        
        playAgainButton.run(scaleSequence) {
            // Reset game manager and start new game
            GameManager.shared.resetGame()
            
            // Transition to game scene
            let gameScene = GameScene()
            gameScene.scaleMode = .aspectFill
            
            let transition = SKTransition.fade(withDuration: Constants.sceneTransitionDuration)
            self.view?.presentScene(gameScene, transition: transition)
        }
    }
    
    private func returnToMenu() {
        // Add button press effect
        let scaleDown = SKAction.scale(to: 0.9, duration: 0.1)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
        let scaleSequence = SKAction.sequence([scaleDown, scaleUp])
        
        menuButton.run(scaleSequence) {
            // Reset game manager
            GameManager.shared.resetGame()
            
            // Transition to main menu
            let mainMenuScene = MainMenuScene()
            mainMenuScene.scaleMode = .aspectFill
            
            let transition = SKTransition.fade(withDuration: Constants.sceneTransitionDuration)
            self.view?.presentScene(mainMenuScene, transition: transition)
        }
    }
    
    // MARK: - Scene Lifecycle
    override func willMove(from view: SKView) {
        // Clean up when leaving scene
        removeAllActions()
    }
    
    // MARK: - Scene Updates
    override func update(_ currentTime: TimeInterval) {
        // No continuous updates needed for game over scene
    }
}