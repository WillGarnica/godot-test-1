# Player System with Factory-Strategy Pattern

This system implements the Factory-Strategy pattern to handle different player types in the endless runner game.

## System Structure

### Main Files

- **`PlayerType.gd`** - Defines player types and their configurations
- **`PlayerStrategy.gd`** - Abstract base class for movement strategies
- **`PlayerFactory.gd`** - Factory for creating player instances
- **`Player.gd`** - Main player controller (refactored)

### Specific Strategies

- **`RunnerStrategy.gd`** - Basic balanced player
- **`FlyerStrategy.gd`** - Fast player with reduced margins
- **`TankStrategy.gd`** - Slow but resistant player
- **`NinjaStrategy.gd`** - Agile player with dodge ability
- **`MageStrategy.gd`** - Player with teleport ability
- **`SpeedsterStrategy.gd`** - Extremely fast but fragile player

### Testing

- **`PlayerTester.gd`** - Script to test different player types

## Available Player Types

### 1. Runner (Basic)
- **Speed**: 300
- **Health**: 1
- **Special ability**: None
- **Score multiplier**: 1.0x

### 2. Flyer
- **Speed**: 400
- **Health**: 1
- **Special ability**: None
- **Score multiplier**: 1.2x
- **Features**: Reduced screen margins

### 3. Tank
- **Speed**: 200
- **Health**: 3
- **Special ability**: None
- **Score multiplier**: 0.8x
- **Features**: Reduces damage taken

### 4. Ninja
- **Speed**: 350
- **Health**: 1
- **Special ability**: Dodge (2s cooldown)
- **Score multiplier**: 1.1x
- **Features**: 30% dodge chance

### 5. Mage
- **Speed**: 280
- **Health**: 1
- **Special ability**: Teleport (5s cooldown)
- **Score multiplier**: 1.3x
- **Features**: Teleports to safe position

### 6. Speedster
- **Speed**: 500
- **Health**: 1
- **Special ability**: None
- **Score multiplier**: 1.5x
- **Features**: Takes extra damage (more fragile)

## System Usage

### Create a Player

```gdscript
# Create specific player
var player = PlayerFactory.create_player(PlayerType.Type.RUNNER, Vector2(100, 300), parent)

# Create random player
var player = PlayerFactory.create_random_player(Vector2(100, 300), parent)

# Create player by name
var player = PlayerFactory.create_player_by_name("ninja", Vector2(100, 300), parent)
```

### Create a Team

```gdscript
# Create balanced team
var team = PlayerFactory.create_team("balanced", Vector2(100, 300), parent)

# Create speed team
var team = PlayerFactory.create_team("speed", Vector2(100, 300), parent)
```

### Using PlayerTester

1. Attach `PlayerTester.gd` script to a node in your scene
2. Assign a container for test players
3. Use the following keys:

**Tester Controls:**
- **1-6**: Switch to specific player type
- **N**: Next player type
- **P**: Previous player type
- **R**: Respawn current player
- **T**: Test team spawn
- **H**: Show help
- **D**: Damage current player
- **F1**: Heal current player
- **SPACE**: Use special ability

## System Events

The system emits the following events through EventBus:

- `player_type_changed(new_type)` - When player type changes
- `player_health_changed(current_health, max_health)` - When health changes
- `player_special_ability_used(ability_name)` - When special ability is used
- `player_died` - When player dies
- `player_respawned` - When player respawns

## Extensibility

### Add New Player Type

1. Add new type in `PlayerType.gd`:
```gdscript
enum Type {
    RUNNER,
    FLYER,
    TANK,
    NINJA,
    MAGE,
    SPEEDSTER,
    NEW_TYPE  # New type
}
```

2. Add configuration in `get_config()`:
```gdscript
Type.NEW_TYPE:
    return {
        "name": "New Type",
        "description": "Description here",
        "fly_speed": 300.0,
        "health": 1,
        "max_health": 1,
        "dodge_chance": 0.0,
        "special_ability": "none",
        "special_cooldown": 0.0,
        "color": Color(1, 1, 1, 1),
        "size": Vector2(32, 32),
        "margin_top": 50.0,
        "margin_bottom": 50.0,
        "score_multiplier": 1.0
    }
```

3. Create new strategy in `strategies/NewTypeStrategy.gd`
4. Add case in `PlayerFactory.gd`

### Add New Special Ability

1. Add ability name in player configuration
2. Implement logic in specific strategy
3. Add case in `_apply_special_ability()` of `PlayerStrategy.gd`

## System Advantages

- **Modularity**: Each player type is independent
- **Extensibility**: Easy to add new types and abilities
- **Maintainability**: Organized and easy to maintain code
- **Testing**: Complete testing system included
- **Consistency**: Same architecture as obstacle system
- **Events**: Integrated event system for communication
