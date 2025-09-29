class_name GameSignals
extends Node
## Centralized signal system for the game
## All game signals are defined and managed here

# Singleton instance
static var instance: GameSignals

# Game State Signals
signal game_started
signal game_paused
signal game_resumed
signal game_over(final_score: int)
signal game_restarted

# Player Signals
signal player_hit_obstacle
signal player_position_changed(position: Vector2)

# Obstacle Signals
signal obstacle_spawned(obstacle: Area2D)
signal obstacle_destroyed(obstacle: Area2D)
signal obstacle_off_screen(obstacle: Area2D)

# Scoring Signals
signal score_updated(new_score: int)
signal high_score_updated(new_high_score: int)
signal score_bonus_earned(bonus_type: String, amount: int)

# UI Signals
signal ui_score_updated(score: int)
signal ui_high_score_updated(high_score: int)
signal ui_game_over_shown(final_score: int)
signal ui_game_over_hidden

# System Signals
signal obstacle_container_ready(container: Node2D)
signal debug_toggled(enabled: bool)

func _ready() -> void:
	# Set singleton instance
	instance = self
	
	# Connect internal signals
	_connect_internal_signals()

func _connect_internal_signals() -> void:
	# Connect obstacle signals to debug system
	obstacle_spawned.connect(_on_obstacle_spawned)
	obstacle_destroyed.connect(_on_obstacle_destroyed)

func _on_obstacle_spawned(obstacle: Area2D) -> void:
	# Notify debug system
	var debug_manager = get_tree().get_first_node_in_group("debug_manager")
	if debug_manager:
		debug_manager.log_obstacle_spawn(obstacle, obstacle.position)

func _on_obstacle_destroyed(obstacle: Area2D) -> void:
	# Notify debug system
	var debug_manager = get_tree().get_first_node_in_group("debug_manager")
	if debug_manager:
		debug_manager.log_message("Obstacle destroyed at position: %s" % obstacle.position, 
						DebugManager.DebugCategory.OBSTACLES, DebugManager.LogLevel.DEBUG)

# Static helper functions
static func emit_game_started() -> void:
	if instance:
		instance.game_started.emit()

static func emit_game_over(final_score: int) -> void:
	if instance:
		instance.game_over.emit(final_score)

static func emit_obstacle_spawned(obstacle: Area2D) -> void:
	if instance:
		instance.obstacle_spawned.emit(obstacle)

static func emit_obstacle_destroyed(obstacle: Area2D) -> void:
	if instance:
		instance.obstacle_destroyed.emit(obstacle)

static func emit_score_updated(score: int) -> void:
	if instance:
		instance.score_updated.emit(score)

static func emit_player_hit_obstacle() -> void:
	if instance:
		instance.player_hit_obstacle.emit()

static func emit_debug_message(message: String, level: DebugManager.LogLevel = DebugManager.LogLevel.INFO) -> void:
	if instance:
		var debug_manager = instance.get_tree().get_first_node_in_group("debug_manager")
		if debug_manager:
			debug_manager.log_message(message, DebugManager.DebugCategory.OBSTACLES, level)
