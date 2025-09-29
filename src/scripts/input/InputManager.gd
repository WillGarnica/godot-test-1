class_name InputManager
extends Node
## Centralized input management system
## Handles all input events and delegates to appropriate systems

@export var debug_enabled: bool = false

# Input action mappings
const INPUT_ACTIONS = {
	"move_up": ["ui_up", "ui_accept"],
	"move_down": ["ui_down"],
	"pause": ["ui_cancel"],
	"restart": ["ui_select"],
	"debug_toggle": ["ui_home"],
	"spawn_obstacle": ["ui_page_up"],
	"clear_obstacles": ["ui_page_down"]
}

func _ready() -> void:
	# Add to input_manager group
	add_to_group("input_manager")
	add_to_group("debug_manager")

func _input(event: InputEvent) -> void:
	if not _is_input_enabled():
		return
	
	_handle_debug_input(event)
	_handle_game_input(event)

func _is_input_enabled() -> bool:
	# Check if game is in a state that accepts input
	var game_state = get_tree().get_first_node_in_group("game_state")
	if game_state and game_state.has_method("is_playing"):
		return game_state.is_playing() or game_state.is_paused()
	return true

func _handle_debug_input(event: InputEvent) -> void:
	if not debug_enabled:
		return
	
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_D:
				_toggle_debug()
			KEY_T:
				_spawn_test_obstacle()
			KEY_C:
				_clear_obstacles()
			KEY_B:
				_toggle_boundary_visualization()
			KEY_1:
				_spawn_specific_obstacle(ObstacleType.Type.STATIC_BOX)
			KEY_2:
				_spawn_specific_obstacle(ObstacleType.Type.MOVING_BOX)
			KEY_3:
				_spawn_specific_obstacle(ObstacleType.Type.SPIKE)

func _handle_game_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ESCAPE:
				_toggle_pause()
			KEY_R:
				_restart_game()

func _toggle_debug() -> void:
	debug_enabled = !debug_enabled
	EventBus.emit_debug_toggled(debug_enabled)

func _spawn_test_obstacle() -> void:
	var debug_manager = get_tree().get_first_node_in_group("debug_manager")
	if debug_manager and debug_manager.has_method("spawn_test_obstacle"):
		debug_manager.spawn_test_obstacle()

func _spawn_specific_obstacle(type: ObstacleType.Type) -> void:
	var debug_manager = get_tree().get_first_node_in_group("debug_manager")
	if debug_manager and debug_manager.has_method("spawn_test_obstacle"):
		debug_manager.spawn_test_obstacle(type)

func _clear_obstacles() -> void:
	var debug_manager = get_tree().get_first_node_in_group("debug_manager")
	if debug_manager and debug_manager.has_method("clear_all_obstacles"):
		debug_manager.clear_all_obstacles()

func _toggle_boundary_visualization() -> void:
	var boundary_viz = get_tree().get_first_node_in_group("debug_manager")
	if boundary_viz and boundary_viz.has_method("toggle_boundaries"):
		boundary_viz.toggle_boundaries()

func _toggle_pause() -> void:
	var game_manager = get_tree().get_first_node_in_group("game_manager")
	if game_manager and game_manager.has_method("pause_game"):
		if game_manager.is_game_playing():
			game_manager.pause_game()
		else:
			game_manager.resume_game()

func _restart_game() -> void:
	var game_manager = get_tree().get_first_node_in_group("game_manager")
	if game_manager and game_manager.has_method("restart_game"):
		game_manager.restart_game()

# Public API
func set_debug_enabled(enabled: bool) -> void:
	debug_enabled = enabled

func is_debug_enabled() -> bool:
	return debug_enabled
