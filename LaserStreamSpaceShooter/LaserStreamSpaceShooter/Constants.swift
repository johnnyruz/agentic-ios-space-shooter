import Foundation
import UIKit

struct Constants {
    
    // MARK: - Game Configuration
    static let initialLives = 3
    static let pointsPerEnemy = 10
    static let gameSpeed: TimeInterval = 60.0 // 60 FPS
    
    // MARK: - Gun Configuration
    static let gunSpeed: CGFloat = 500.0
    static let gunSize = CGSize(width: 60, height: 40)
    static let gunBottomMargin: CGFloat = 50.0
    
    // MARK: - Bullet Configuration
    static let bulletSpeed: CGFloat = 600.0
    static let bulletSize = CGSize(width: 8, height: 20)
    static let bulletFireRate: TimeInterval = 0.1 // Bullets per second
    static let maxBulletsOnScreen = 50
    
    // MARK: - Enemy Configuration
    static let enemySpeed: CGFloat = 150.0
    static let enemySize = CGSize(width: 40, height: 40)
    static let enemySpawnRate: TimeInterval = 1.0 // Initial spawn rate
    static let enemySpawnRateIncrease: TimeInterval = 0.95 // Multiplier for faster spawning
    static let minEnemySpawnRate: TimeInterval = 0.3
    static let maxEnemiesOnScreen = 20
    
    // MARK: - Screen Configuration
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    static let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    // MARK: - Physics Categories
    static let bulletCategory: UInt32 = 0x1 << 0
    static let enemyCategory: UInt32 = 0x1 << 1
    static let gunCategory: UInt32 = 0x1 << 2
    static let screenBoundaryCategory: UInt32 = 0x1 << 3
    
    // MARK: - Colors
    static let backgroundColor = UIColor.black
    static let bulletColor = UIColor.cyan
    static let gunColor = UIColor.green
    static let enemyColor = UIColor.red
    static let explosionColor = UIColor.yellow
    
    // MARK: - UI Configuration
    static let fontSize: CGFloat = 24.0
    static let buttonFontSize: CGFloat = 32.0
    static let titleFontSize: CGFloat = 48.0
    static let hudMargin: CGFloat = 20.0
    
    // MARK: - Animation Durations
    static let explosionDuration: TimeInterval = 0.3
    static let sceneTransitionDuration: TimeInterval = 0.5
    
    // MARK: - UserDefaults Keys
    static let highScoreKey = "HighScore"
    static let soundEnabledKey = "SoundEnabled"
    
    // MARK: - Sound File Names
    static let backgroundMusicFile = "background_music.mp3"
    static let bulletSoundFile = "bullet_sound.wav"
    static let explosionSoundFile = "explosion_sound.wav"
    static let gameOverSoundFile = "game_over_sound.wav"
}