import Foundation
import AVFoundation

class AudioManager {
    
    // MARK: - Singleton
    static let shared = AudioManager()
    private init() {}
    
    // MARK: - Audio Players
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var soundEffectPlayers: [AVAudioPlayer] = []
    
    // MARK: - Setup
    func setupAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session setup failed: \(error)")
        }
        
        setupBackgroundMusic()
    }
    
    private func setupBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "background_music", withExtension: "mp3") else {
            print("Background music file not found")
            return
        }
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1 // Loop infinitely
            backgroundMusicPlayer?.volume = 0.5
            backgroundMusicPlayer?.prepareToPlay()
        } catch {
            print("Failed to setup background music: \(error)")
        }
    }
    
    // MARK: - Background Music Control
    func playBackgroundMusic() {
        guard GameManager.shared.isSoundEnabled else { return }
        backgroundMusicPlayer?.play()
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }
    
    func pauseBackgroundMusic() {
        backgroundMusicPlayer?.pause()
    }
    
    func resumeBackgroundMusic() {
        guard GameManager.shared.isSoundEnabled else { return }
        backgroundMusicPlayer?.play()
    }
    
    // MARK: - Sound Effects
    func playBulletSound() {
        guard GameManager.shared.isSoundEnabled else { return }
        playSoundEffect(filename: "bullet_sound", fileExtension: "wav", volume: 0.3)
    }
    
    func playExplosionSound() {
        guard GameManager.shared.isSoundEnabled else { return }
        playSoundEffect(filename: "explosion_sound", fileExtension: "wav", volume: 0.7)
    }
    
    func playGameOverSound() {
        guard GameManager.shared.isSoundEnabled else { return }
        playSoundEffect(filename: "game_over_sound", fileExtension: "wav", volume: 0.8)
    }
    
    private func playSoundEffect(filename: String, fileExtension: String, volume: Float = 1.0) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            print("Sound file not found: \(filename).\(fileExtension)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = volume
            player.prepareToPlay()
            player.play()
            
            // Add to array to prevent deallocation
            soundEffectPlayers.append(player)
            
            // Remove player after sound finishes
            DispatchQueue.main.asyncAfter(deadline: .now() + player.duration + 0.1) {
                self.soundEffectPlayers.removeAll { $0 == player }
            }
        } catch {
            print("Failed to play sound effect: \(error)")
        }
    }
    
    // MARK: - Volume Control
    func setBackgroundMusicVolume(_ volume: Float) {
        backgroundMusicPlayer?.volume = volume
    }
    
    func setSoundEffectsVolume(_ volume: Float) {
        // This would be used for future volume control implementation
    }
    
    // MARK: - Cleanup
    func stopAllSounds() {
        stopBackgroundMusic()
        soundEffectPlayers.forEach { $0.stop() }
        soundEffectPlayers.removeAll()
    }
}