class_name GameConfig
extends RefCounted
## Centralized configuration for the game
## All game constants and settings in one place

# Game Settings
const GAME_TITLE = "Endless Runner"
const VERSION = "1.0.0"

# Viewport Settings
const DEFAULT_VIEWPORT_SIZE = Vector2(1152, 648)
const OBSTACLE_SPAWN_OFFSET = 50.0
const OBSTACLE_DESTROY_OFFSET = -100.0

# Player Settings
const PLAYER_START_POSITION = Vector2(576, 548)  # Center X, near bottom (648 - 100)
const PLAYER_FLY_SPEED = 300.0
const PLAYER_MARGIN_LEFT = 50.0
const PLAYER_MARGIN_RIGHT = 50.0

# Obstacle Settings
const OBSTACLE_BASE_SPEED = 200.0
const OBSTACLE_SPAWN_WIDTH_MIN = 100.0  # Spawn from left side
const OBSTACLE_SPAWN_WIDTH_MAX = 1052.0  # Spawn from right side (1152 - 100)
const OBSTACLE_SPAWN_TIMER_MIN = 1.0
const OBSTACLE_SPAWN_TIMER_MAX = 3.0

# Scoring Settings
const SCORE_PER_SECOND = 10
const OBSTACLE_BONUS = 50
const SURVIVAL_BONUS = 100

# Difficulty Settings
const DIFFICULTY_SETTINGS = {
	"easy": {
		"spawn_timer_min": 2.0,
		"spawn_timer_max": 4.0,
		"obstacle_speed": 150.0
	},
	"medium": {
		"spawn_timer_min": 1.0,
		"spawn_timer_max": 3.0,
		"obstacle_speed": 200.0
	},
	"hard": {
		"spawn_timer_min": 0.5,
		"spawn_timer_max": 2.0,
		"obstacle_speed": 250.0
	}
}

# UI Settings
const UI_SCORE_FONT_SIZE = 24
const UI_GAME_OVER_FONT_SIZE = 20

# File Paths
const HIGH_SCORE_FILE = "user://high_score.save"

# Debug Settings
const DEBUG_LOG_LEVEL = DebugManager.LogLevel.INFO
const DEBUG_OBSTACLE_MOVEMENT_INTERVAL = 30  # frames

# Utility functions
static func get_difficulty_settings(difficulty: String) -> Dictionary:
	return DIFFICULTY_SETTINGS.get(difficulty, DIFFICULTY_SETTINGS["easy"])

static func get_obstacle_spawn_position(viewport_size: Vector2, width_range: Vector2) -> Vector2:
	var spawn_x = randf_range(width_range.x, width_range.y)
	return Vector2(spawn_x, -OBSTACLE_SPAWN_OFFSET)  # Spawn above screen

static func is_obstacle_off_screen(position: Vector2, viewport_size: Vector2 = Vector2(1152, 648)) -> bool:
	# Destroy when below screen (obstacles fall from top to bottom)
	return position.y > viewport_size.y + abs(OBSTACLE_DESTROY_OFFSET)
