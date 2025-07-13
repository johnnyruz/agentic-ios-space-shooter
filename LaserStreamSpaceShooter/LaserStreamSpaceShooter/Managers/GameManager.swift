import Foundation

class GameManager {
    
    // MARK: - Singleton
    static let shared = GameManager()
    private init() {}
    
    // MARK: - Game State
    private(set) var currentScore = 0
    private(set) var currentLives = Constants.initialLives
    private(set) var isGameActive = false
    private(set) var enemySpawnRate = Constants.enemySpawnRate
    
    // MARK: - High Score
    var highScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.highScoreKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.highScoreKey)
        }
    }
    
    // MARK: - Sound Settings
    var isSoundEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.soundEnabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.soundEnabledKey)
        }
    }
    
    // MARK: - Game Control
    func startNewGame() {
        currentScore = 0
        currentLives = Constants.initialLives
        enemySpawnRate = Constants.enemySpawnRate
        isGameActive = true
    }
    
    func endGame() {
        isGameActive = false
        
        // Update high score if necessary
        if currentScore > highScore {
            highScore = currentScore
        }
    }
    
    func pauseGame() {
        isGameActive = false
    }
    
    func resumeGame() {
        isGameActive = true
    }
    
    // MARK: - Score Management
    func addPoints(_ points: Int) {
        currentScore += points
        
        // Increase difficulty based on score
        increaseDifficulty()
    }
    
    private func increaseDifficulty() {
        // Increase enemy spawn rate every 500 points
        if currentScore % 500 == 0 && currentScore > 0 {
            enemySpawnRate = max(enemySpawnRate * Constants.enemySpawnRateIncrease, Constants.minEnemySpawnRate)
        }
    }
    
    // MARK: - Lives Management
    func loseLife() {
        currentLives -= 1
        
        if currentLives <= 0 {
            endGame()
        }
    }
    
    func addLife() {
        currentLives += 1
    }
    
    // MARK: - Getters
    func getScore() -> Int {
        return currentScore
    }
    
    func getLives() -> Int {
        return currentLives
    }
    
    func getEnemySpawnRate() -> TimeInterval {
        return enemySpawnRate
    }
    
    func isGameOver() -> Bool {
        return currentLives <= 0
    }
    
    // MARK: - Reset
    func resetGame() {
        currentScore = 0
        currentLives = Constants.initialLives
        enemySpawnRate = Constants.enemySpawnRate
        isGameActive = false
    }
}