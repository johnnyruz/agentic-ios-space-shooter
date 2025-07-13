import SpriteKit

class MainMenuScene: SKScene {
    
    // MARK: - UI Elements
    private var titleLabel: SKLabelNode!
    private var startButton: SKLabelNode!
    private var highScoreLabel: SKLabelNode!
    private var soundToggleButton: SKLabelNode!
    private var backgroundNode: SKSpriteNode!
    
    // MARK: - Scene Setup
    override func didMove(to view: SKView) {
        setupScene()
        setupBackground()
        setupUI()
        setupAudio()
    }
    
    private func setupScene() {
        backgroundColor = Constants.backgroundColor
        size = CGSize(width: Constants.screenWidth, height: Constants.screenHeight)
        scaleMode = .aspectFill
    }
    
    private func setupBackground() {
        // Create scrolling space background
        backgroundNode = SKSpriteNode(color: .black, size: size)
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.zPosition = -10
        addChild(backgroundNode)
        
        // Add stars
        createStarField()
    }
    
    private func createStarField() {
        for _ in 0..<100 {
            let star = SKSpriteNode(color: .white, size: CGSize(width: 2, height: 2))
            star.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            )
            star.zPosition = -5
            
            // Add twinkling animation
            let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: Double.random(in: 0.5...2.0))
            let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: Double.random(in: 0.5...2.0))
            let twinkle = SKAction.sequence([fadeOut, fadeIn])
            let repeatTwinkle = SKAction.repeatForever(twinkle)
            star.run(repeatTwinkle)
            
            addChild(star)
        }
    }
    
    private func setupUI() {
        // Title
        titleLabel = SKLabelNode(text: "LASER STREAM")
        titleLabel.fontName = "Helvetica-Bold"
        titleLabel.fontSize = Constants.titleFontSize
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.7)
        titleLabel.zPosition = 1
        addChild(titleLabel)
        
        let subtitleLabel = SKLabelNode(text: "SPACE SHOOTER")
        subtitleLabel.fontName = "Helvetica-Bold"
        subtitleLabel.fontSize = Constants.titleFontSize * 0.6
        subtitleLabel.fontColor = .cyan
        subtitleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.65)
        subtitleLabel.zPosition = 1
        addChild(subtitleLabel)
        
        // Start Button
        startButton = SKLabelNode(text: "START GAME")
        startButton.fontName = "Helvetica-Bold"
        startButton.fontSize = Constants.buttonFontSize
        startButton.fontColor = .green
        startButton.position = CGPoint(x: size.width / 2, y: size.height * 0.45)
        startButton.name = "startButton"
        startButton.zPosition = 1
        addChild(startButton)
        
        // High Score
        updateHighScoreDisplay()
        
        // Sound Toggle Button
        soundToggleButton = SKLabelNode(text: getSoundToggleText())
        soundToggleButton.fontName = "Helvetica-Bold"
        soundToggleButton.fontSize = Constants.fontSize
        soundToggleButton.fontColor = .yellow
        soundToggleButton.position = CGPoint(x: size.width / 2, y: size.height * 0.25)
        soundToggleButton.name = "soundToggleButton"
        soundToggleButton.zPosition = 1
        addChild(soundToggleButton)
        
        // Add pulsing animation to start button
        let pulseAction = SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.8),
            SKAction.scale(to: 1.0, duration: 0.8)
        ])
        let repeatPulse = SKAction.repeatForever(pulseAction)
        startButton.run(repeatPulse)
    }
    
    private func updateHighScoreDisplay() {
        highScoreLabel?.removeFromParent()
        
        let highScore = GameManager.shared.highScore
        highScoreLabel = SKLabelNode(text: "HIGH SCORE: \(highScore)")
        highScoreLabel.fontName = "Helvetica-Bold"
        highScoreLabel.fontSize = Constants.fontSize
        highScoreLabel.fontColor = .white
        highScoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.35)
        highScoreLabel.zPosition = 1
        addChild(highScoreLabel)
    }
    
    private func getSoundToggleText() -> String {
        return GameManager.shared.isSoundEnabled ? "SOUND: ON" : "SOUND: OFF"
    }
    
    private func setupAudio() {
        AudioManager.shared.setupAudio()
        AudioManager.shared.playBackgroundMusic()
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
        case "startButton":
            startGame()
        case "soundToggleButton":
            toggleSound()
        default:
            break
        }
    }
    
    private func startGame() {
        // Add button press effect
        let scaleDown = SKAction.scale(to: 0.9, duration: 0.1)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
        let scaleSequence = SKAction.sequence([scaleDown, scaleUp])
        
        startButton.run(scaleSequence) {
            // Transition to game scene
            let gameScene = GameScene()
            gameScene.scaleMode = .aspectFill
            
            let transition = SKTransition.fade(withDuration: Constants.sceneTransitionDuration)
            self.view?.presentScene(gameScene, transition: transition)
        }
    }
    
    private func toggleSound() {
        GameManager.shared.isSoundEnabled.toggle()
        soundToggleButton.text = getSoundToggleText()
        
        // Add button press effect
        let scaleDown = SKAction.scale(to: 0.9, duration: 0.1)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
        let scaleSequence = SKAction.sequence([scaleDown, scaleUp])
        soundToggleButton.run(scaleSequence)
        
        // Update audio state
        if GameManager.shared.isSoundEnabled {
            AudioManager.shared.playBackgroundMusic()
        } else {
            AudioManager.shared.stopBackgroundMusic()
        }
    }
    
    // MARK: - Scene Lifecycle
    override func willMove(from view: SKView) {
        // Clean up when leaving scene
        removeAllActions()
    }
    
    // MARK: - Scene Updates
    override func update(_ currentTime: TimeInterval) {
        // Update high score display if needed
        updateHighScoreDisplay()
    }
}