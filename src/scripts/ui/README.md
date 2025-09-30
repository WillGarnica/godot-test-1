# Main Menu System

This system provides a complete main menu interface similar to the example image, with vibrant colors, animated backgrounds, and smooth transitions.

## Features

### Main Menu
- **Animated Background**: Moving clouds, swaying trees, and parallax hills
- **Vibrant UI**: Orange buttons with brown borders and shadow effects
- **Smooth Animations**: Button hover effects, entrance animations, and transitions
- **Keyboard Shortcuts**: Full keyboard navigation support

### Menu Structure
- **Main Menu**: Play, Options, Credits buttons
- **Side Icons**: Shop, Trophy, Settings icons
- **Pause Menu**: Resume, Restart, Main Menu options
- **Copyright Text**: Placeholder for copyright information

## Controls

### Main Menu
- **1-6**: Switch player types (if PlayerTester is active)
- **ENTER/SPACE**: Start game
- **O**: Options
- **C**: Credits
- **S**: Shop
- **A**: Achievements
- **F1**: Settings
- **ESC**: Quit game

### Pause Menu
- **ENTER/SPACE**: Resume game
- **R**: Restart game
- **M**: Main menu
- **ESC**: Resume game

## Files Structure

### Scenes
- `MainMenu.tscn` - Main menu scene
- `PauseMenu.tscn` - Pause menu scene
- `AnimatedBackground.tscn` - Background with trees and clouds

### Scripts
- `MainMenuUI.gd` - Main menu controller
- `PauseMenuUI.gd` - Pause menu controller
- `AnimatedBackground.gd` - Background animation controller
- `MenuManager.gd` - Centralized menu navigation

### Resources
- `MenuTheme.tres` - UI theme with button styles

## Integration

The menu system integrates with:
- **EventBus**: For game state communication
- **Player System**: For player type selection
- **Game System**: For scene transitions

## Customization

### Colors
- **Primary**: Orange (#FF9933)
- **Secondary**: Dark Brown (#663300)
- **Text**: White with brown outline
- **Background**: Sky blue to green gradient

### Animations
- **Button Hover**: Scale up + brightness increase
- **Button Press**: Scale down + scale up
- **Menu Entrance**: Fade in + scale up
- **Background**: Continuous cloud movement and tree swaying

## Future Enhancements

- Options menu with settings
- Credits screen
- Shop system
- Achievements system
- Sound effects and music
- Save/load system
- Multiple language support
