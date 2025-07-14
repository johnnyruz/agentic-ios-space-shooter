# Laser Stream Space Shooter

A 2D arcade-style vertical shooter game for iOS built using Swift and SpriteKit.

## Features

- **Rapid-fire laser stream**: Continuous bullet firing with touch-controlled horizontal movement
- **Progressive difficulty**: Enemy spawn rate increases with score
- **Touch controls**: Intuitive left/right movement by dragging finger
- **Visual effects**: Glowing bullets, explosions, screen shake, and particle effects
- **Sound system**: Background music and sound effects with toggle option
- **Score system**: Points for destroying enemies with high score tracking
- **Multiple scenes**: Main menu, game play, and game over screens
- **Portrait-only**: Optimized for iPhone portrait mode

## Requirements

- iOS 15.0+
- Xcode 15.0+
- iPhone (optimized for portrait mode)

## Project Structure

```
LaserStreamSpaceShooter/
├── LaserStreamSpaceShooter.xcodeproj/    # Xcode project file
├── LaserStreamSpaceShooter/
│   ├── AppDelegate.swift                 # App lifecycle
│   ├── SceneDelegate.swift               # Scene management
│   ├── GameViewController.swift          # Main view controller
│   ├── Constants.swift                   # Game configuration
│   ├── Managers/
│   │   ├── GameManager.swift             # Game state management
│   │   └── AudioManager.swift            # Sound management
│   ├── Nodes/
│   │   ├── GunNode.swift                 # Player gun
│   │   ├── BulletNode.swift              # Bullets
│   │   └── EnemyNode.swift               # Enemy ships
│   ├── Scenes/
│   │   ├── MainMenuScene.swift           # Main menu
│   │   ├── GameScene.swift               # Main gameplay
│   │   └── GameOverScene.swift           # Game over screen
│   ├── Base.lproj/
│   │   ├── Main.storyboard               # Main interface
│   │   └── LaunchScreen.storyboard       # Launch screen
│   ├── Assets.xcassets/                  # App icons and images
│   ├── Sounds/                           # Audio files (placeholders)
│   └── Info.plist                        # App configuration
└── README.md                             # This file
```

## Build Instructions

### 1. Open Project in Xcode
```bash
cd LaserStreamSpaceShooter
open LaserStreamSpaceShooter.xcodeproj
```

### 2. Configure Development Team
- Select the project in Xcode navigator
- Go to "Signing & Capabilities" tab
- Select your development team
- Ensure bundle identifier is unique

### 3. Build and Run
- Select iPhone simulator or device
- Press Cmd+R to build and run
- Or use Product → Run from menu

## Game Controls

- **Touch and Drag**: Move gun left/right
- **Automatic Firing**: Bullets fire continuously
- **Menu Navigation**: Tap buttons to navigate

## Game Mechanics

- **Lives**: Start with 3 lives
- **Scoring**: 10 points per enemy destroyed
- **Difficulty**: Enemy spawn rate increases every 500 points
- **Game Over**: When all lives are lost

## Audio Assets (Required)

The game expects the following audio files in the `Sounds/` directory:

- `background_music.mp3` - Looping background music
- `bullet_sound.wav` - Bullet firing sound effect
- `explosion_sound.wav` - Enemy destruction sound
- `game_over_sound.wav` - Game over sound effect

**Note**: These are currently placeholder files. Replace with actual audio files for full functionality.

## Visual Assets

- `spark.png` - Particle effect texture (8x8 pixel white circle recommended)
- App icons in various sizes (configured in Assets.xcassets)

## Customization

### Game Balance
Edit `Constants.swift` to modify:
- Bullet speed and fire rate
- Enemy spawn rates and speed
- Player lives and scoring
- Visual effects and colors

### Visual Styling
- Colors defined in `Constants.swift`
- Particle effects in node classes
- UI styling in scene files

## Architecture

### Core Components
- **GameManager**: Singleton managing game state, score, and progression
- **AudioManager**: Handles background music and sound effects
- **Node Classes**: Encapsulate game object behavior and rendering
- **Scene Classes**: Manage different game screens and user interaction

### Physics System
- Uses SpriteKit physics for collision detection
- Collision categories for bullets, enemies, and boundaries
- Contact delegate pattern for collision handling

## Development Notes

- Portrait orientation only
- Targets iPhone (can be modified for iPad)
- Uses UserDefaults for high score persistence
- Includes pause/resume functionality
- Memory management through object pooling concepts

## Future Enhancements

- Power-ups and weapon upgrades
- Different enemy types and boss battles
- GameCenter integration for leaderboards
- Additional visual effects and animations
- More complex enemy movement patterns

## Troubleshooting

### Common Issues
1. **Missing audio files**: Game will log warnings but continue without sound
2. **Missing spark.png**: Particle effects will use colored rectangles as fallback
3. **Simulator performance**: Some effects may perform better on device

### Performance Tips
- Test on actual device for best performance
- Adjust particle counts in Constants.swift if needed
- Monitor memory usage with large numbers of bullets/enemies

## License

This project is created as a demonstration of iOS game development with SpriteKit. Feel free to use and modify for educational purposes.