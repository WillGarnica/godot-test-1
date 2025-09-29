class_name DebugManager
extends Node
## Unified debug system for the game
## Handles all debugging functionality in one place

@export var debug_enabled: bool = false
@export var log_level: LogLevel = LogLevel.INFO

enum LogLevel {
	ERROR = 0,
	WARN = 1,
	INFO = 2,
	DEBUG = 3
}

# Debug categories
enum DebugCategory {
	OBSTACLES,
	SCORING,
	GAME_STATE,
	SPAWNING,
	UI
}

var obstacle_container: Node2D
var debug_timers: Dictionary = {}

func _ready() -> void:
	# Add to debug_manager group
	add_to_group("debug_manager")
	
	# Find obstacle container
	obstacle_container = get_tree().get_first_node_in_group("obstacle_container")
	if not obstacle_container:
		obstacle_container = get_node("../ObstacleContainer")
	
	if debug_enabled:
		log_message("DebugManager initialized", DebugCategory.OBSTACLES, LogLevel.INFO)

func log_message(message: String, category: DebugCategory = DebugCategory.OBSTACLES, level: LogLevel = LogLevel.INFO) -> void:
	if not debug_enabled or level > log_level:
		return
	
	var category_name = DebugCategory.keys()[category]
	var level_name = LogLevel.keys()[level]
	print("[%s][%s] %s" % [level_name, category_name, message])

func log_obstacle_spawn(obstacle: Area2D, position: Vector2) -> void:
	if not debug_enabled:
		return
	
	log_message("Obstacle spawned - Type: %s, Position: %s" % [
		ObstacleType.Type.keys()[obstacle.obstacle_type], 
		position
	], DebugCategory.OBSTACLES, LogLevel.DEBUG)

func log_obstacle_movement(obstacle: Area2D) -> void:
	if not debug_enabled:
		return
	
	log_message("Obstacle moving - Position: %s, Speed: %s" % [
		obstacle.position, 
		obstacle.base_speed
	], DebugCategory.OBSTACLES, LogLevel.DEBUG)

func spawn_test_obstacle(type: ObstacleType.Type = ObstacleType.Type.STATIC_BOX) -> void:
	if not obstacle_container:
		log_message("Cannot spawn test obstacle - no container found", DebugCategory.OBSTACLES, LogLevel.ERROR)
		return
	
	var viewport_size = get_viewport().get_visible_rect().size
	var test_position = Vector2(viewport_size.x / 2, viewport_size.y / 2)
	
	var obstacle = ObstacleFactory.create_obstacle(type, test_position, obstacle_container)
	if obstacle:
		obstacle.base_speed = 100.0  # Slow for testing
		log_message("Test obstacle created successfully", DebugCategory.OBSTACLES, LogLevel.INFO)
	else:
		log_message("Failed to create test obstacle", DebugCategory.OBSTACLES, LogLevel.ERROR)

func clear_all_obstacles() -> void:
	if not obstacle_container:
		return
	
	var count = obstacle_container.get_child_count()
	for child in obstacle_container.get_children():
		child.queue_free()
	
	log_message("Cleared %d obstacles" % count, DebugCategory.OBSTACLES, LogLevel.INFO)

func get_obstacle_info() -> Dictionary:
	if not obstacle_container:
		return {}
	
	var info = {
		"total_obstacles": obstacle_container.get_child_count(),
		"obstacles": []
	}
	
	for i in range(obstacle_container.get_child_count()):
		var obstacle = obstacle_container.get_child(i)
		if obstacle and obstacle.is_inside_tree():
			info.obstacles.append({
				"index": i,
				"position": obstacle.position,
				"type": ObstacleType.Type.keys()[obstacle.obstacle_type],
				"speed": obstacle.base_speed,
				"visible": obstacle.visible
			})
	
	return info

func print_obstacle_info() -> void:
	var info = get_obstacle_info()
	log_message("=== OBSTACLE INFO ===", DebugCategory.OBSTACLES, LogLevel.INFO)
	log_message("Total obstacles: %d" % info.total_obstacles, DebugCategory.OBSTACLES, LogLevel.INFO)
	
	for obstacle_info in info.obstacles:
		log_message("Obstacle %d: %s" % [obstacle_info.index, obstacle_info], DebugCategory.OBSTACLES, LogLevel.INFO)

# Input handling for debug controls
func _input(event: InputEvent) -> void:
	if not debug_enabled:
		return
	
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_D:
				toggle_debug()
			KEY_T:
				spawn_test_obstacle()
			KEY_C:
				clear_all_obstacles()
			KEY_P:
				print_obstacle_info()
			KEY_1:
				spawn_test_obstacle(ObstacleType.Type.STATIC_BOX)
			KEY_2:
				spawn_test_obstacle(ObstacleType.Type.MOVING_BOX)
			KEY_3:
				spawn_test_obstacle(ObstacleType.Type.SPIKE)
			KEY_B:
				toggle_boundary_visualization()

func toggle_debug() -> void:
	debug_enabled = !debug_enabled
	log_message("Debug %s" % ("enabled" if debug_enabled else "disabled"), DebugCategory.OBSTACLES, LogLevel.INFO)

func toggle_boundary_visualization() -> void:
	var boundary_viz = get_tree().get_first_node_in_group("debug_manager")
	if boundary_viz and boundary_viz.has_method("toggle_boundaries"):
		boundary_viz.toggle_boundaries()
		log_message("Boundary visualization toggled", DebugCategory.OBSTACLES, LogLevel.INFO)
