class_name GameSettings
extends Resource
## Centralized game configuration
## Eliminates magic numbers and provides single source of truth

@export_group("Animation Settings")
@export var button_animation_duration: float = 0.3
@export var button_hover_scale: float = 1.1
@export var button_press_scale: float = 0.95
@export var title_animation_duration: float = 1.0
@export var button_entrance_delay: float = 0.2

@export_group("Background Animation")
@export var cloud_spacing: float = 300.0
@export var cloud_random_range: float = 50.0
@export var tree_sway_range: float = 10.0
@export var hill_parallax_range: float = 15.0
@export var cloud_speed: float = 10.0
@export var tree_sway_speed: float = 2.0
@export var hill_parallax_speed: float = 5.0

@export_group("Player Settings")
@export var default_player_type: PlayerType.Type = PlayerType.Type.RUNNER
@export var player_margin_top: float = 50.0
@export var player_margin_bottom: float = 50.0

@export_group("UI Settings")
@export var button_hover_brightness: float = 1.2
@export var button_entrance_offset: float = 50.0
@export var title_initial_scale: float = 0.5

# Singleton instance
static var instance: GameSettings

func _init() -> void:
	instance = self

# Static access methods
static func get_button_animation_duration() -> float:
	return instance.button_animation_duration if instance else 0.3

static func get_button_hover_scale() -> float:
	return instance.button_hover_scale if instance else 1.1

static func get_button_press_scale() -> float:
	return instance.button_press_scale if instance else 0.95

static func get_cloud_spacing() -> float:
	return instance.cloud_spacing if instance else 300.0

static func get_cloud_random_range() -> float:
	return instance.cloud_random_range if instance else 50.0

static func get_tree_sway_range() -> float:
	return instance.tree_sway_range if instance else 10.0

static func get_hill_parallax_range() -> float:
	return instance.hill_parallax_range if instance else 15.0

static func get_button_entrance_delay() -> float:
	return instance.button_entrance_delay if instance else 0.2

static func get_button_entrance_offset() -> float:
	return instance.button_entrance_offset if instance else 50.0

static func get_title_initial_scale() -> float:
	return instance.title_initial_scale if instance else 0.5

static func get_button_hover_brightness() -> float:
	return instance.button_hover_brightness if instance else 1.2
