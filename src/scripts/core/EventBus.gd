class_name EventBus
extends Node
## Centralized event system for the game
## Replaces direct coupling with event-driven architecture

# Singleton instance
static var instance: EventBus

# Game Events
signal game_started
signal game_paused
signal game_resumed
signal game_over(final_score: int)
signal game_restarted

# Player Events
signal player_hit_obstacle
signal player_position_changed(position: Vector2)
signal player_at_boundary(boundary_type: String)  # "top" or "bottom"
signal player_type_changed(new_type: PlayerType.Type)
signal player_health_changed(current_health: int, max_health: int)
signal player_special_ability_used(ability_name: String)
signal player_died
signal player_respawned

# Obstacle Events
signal obstacle_spawned(obstacle: Area2D)
signal obstacle_destroyed(obstacle: Area2D)
signal obstacle_off_screen(obstacle: Area2D)

# Scoring Events
signal score_updated(new_score: int)
signal high_score_updated(new_high_score: int)
signal score_bonus_earned(bonus_type: String, amount: int)

# UI Events
signal ui_score_updated(score: int)
signal ui_high_score_updated(high_score: int)
signal ui_game_over_shown(final_score: int)
signal ui_game_over_hidden

# System Events
signal obstacle_container_ready(container: Node2D)
signal debug_toggled(enabled: bool)
signal boundary_visualization_toggled(enabled: bool)

func _ready() -> void:
	instance = self

# Static helper functions for easy access
static func emit_game_started() -> void:
	if instance:
		instance.game_started.emit()

static func emit_game_over(final_score: int) -> void:
	if instance:
		instance.game_over.emit(final_score)

static func emit_obstacle_spawned(obstacle: Area2D) -> void:
	if instance:
		instance.obstacle_spawned.emit(obstacle)

static func emit_player_hit_obstacle() -> void:
	if instance:
		instance.player_hit_obstacle.emit()

static func emit_score_updated(score: int) -> void:
	if instance:
		instance.score_updated.emit(score)

static func emit_ui_score_updated(score: int) -> void:
	if instance:
		instance.ui_score_updated.emit(score)

static func emit_ui_game_over_shown(final_score: int) -> void:
	if instance:
		instance.ui_game_over_shown.emit(final_score)

static func emit_ui_game_over_hidden() -> void:
	if instance:
		instance.ui_game_over_hidden.emit()

static func emit_boundary_visualization_toggled(enabled: bool) -> void:
	if instance:
		instance.boundary_visualization_toggled.emit(enabled)

static func emit_debug_toggled(enabled: bool) -> void:
	if instance:
		instance.debug_toggled.emit(enabled)

static func emit_game_restarted() -> void:
	if instance:
		instance.game_restarted.emit()

static func emit_obstacle_destroyed(obstacle: Area2D) -> void:
	if instance:
		instance.obstacle_destroyed.emit(obstacle)

static func emit_obstacle_off_screen(obstacle: Area2D) -> void:
	if instance:
		instance.obstacle_off_screen.emit(obstacle)

static func emit_player_position_changed(position: Vector2) -> void:
	if instance:
		instance.player_position_changed.emit(position)

static func emit_player_at_boundary(boundary_type: String) -> void:
	if instance:
		instance.player_at_boundary.emit(boundary_type)

static func emit_high_score_updated(high_score: int) -> void:
	if instance:
		instance.high_score_updated.emit(high_score)

static func emit_score_bonus_earned(bonus_type: String, amount: int) -> void:
	if instance:
		instance.score_bonus_earned.emit(bonus_type, amount)

static func emit_ui_high_score_updated(high_score: int) -> void:
	if instance:
		instance.ui_high_score_updated.emit(high_score)

static func emit_obstacle_container_ready(container: Node2D) -> void:
	if instance:
		instance.obstacle_container_ready.emit(container)

# Player Events
static func emit_player_type_changed(new_type: PlayerType.Type) -> void:
	if instance:
		instance.player_type_changed.emit(new_type)

static func emit_player_health_changed(current_health: int, max_health: int) -> void:
	if instance:
		instance.player_health_changed.emit(current_health, max_health)

static func emit_player_special_ability_used(ability_name: String) -> void:
	if instance:
		instance.player_special_ability_used.emit(ability_name)

static func emit_player_died() -> void:
	if instance:
		instance.player_died.emit()

static func emit_player_respawned() -> void:
	if instance:
		instance.player_respawned.emit()
