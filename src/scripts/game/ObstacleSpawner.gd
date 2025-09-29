class_name ObstacleSpawner
extends Node
## Handles obstacle spawning logic and timing

signal obstacle_spawned(obstacle: Area2D)

@export var spawn_timer_min: float = GameConfig.OBSTACLE_SPAWN_TIMER_MIN
@export var spawn_timer_max: float = GameConfig.OBSTACLE_SPAWN_TIMER_MAX
@export var obstacle_speed: float = GameConfig.OBSTACLE_BASE_SPEED
@export var spawn_height_range: Vector2 = Vector2(GameConfig.OBSTACLE_SPAWN_HEIGHT_MIN, GameConfig.OBSTACLE_SPAWN_HEIGHT_MAX)

var spawn_timer: float = 0.0
var next_spawn_time: float = 0.0
var is_spawning: bool = true

@onready var obstacle_container: Node2D = get_node("../../ObstacleContainer")

func _ready() -> void:
	# Set initial spawn time
	next_spawn_time = randf_range(spawn_timer_min, spawn_timer_max)
	
	# Verify container
	if obstacle_container:
		print("INFO: ObstacleSpawner initialized successfully")
	else:
		print("ERROR: ObstacleContainer not found!")

func _process(delta: float) -> void:
	if not is_spawning or not obstacle_container:
		return
	
	# Update spawn timer
	spawn_timer += delta
	
	# Spawn obstacle when timer reaches next spawn time
	if spawn_timer >= next_spawn_time:
		spawn_obstacle()
		spawn_timer = 0.0
		next_spawn_time = randf_range(spawn_timer_min, spawn_timer_max)

func spawn_obstacle() -> void:
	if not obstacle_container:
		print("ERROR: ObstacleContainer not found!")
		return
	
	# Create new obstacle using the factory
	var viewport_size = get_viewport().get_visible_rect().size
	var spawn_position = GameConfig.get_obstacle_spawn_position(viewport_size, spawn_height_range)
	
	# Use factory to create random obstacle
	var obstacle = ObstacleFactory.create_random_obstacle(spawn_position, obstacle_container)
	
	if not obstacle:
		print("ERROR: Failed to create obstacle!")
		return
	
	# Set obstacle speed
	obstacle.base_speed = obstacle_speed
	
	# Log successful spawn
	print("DEBUG: Obstacle spawned at position: %s" % spawn_position)
	
	# Emit signal
	obstacle_spawned.emit(obstacle)

func spawn_obstacle_sequence(positions: Array[Vector2]) -> void:
	# Spawn a sequence of obstacles at given positions
	for pos in positions:
		var obstacle = ObstacleFactory.create_random_obstacle(pos, obstacle_container)
		obstacle.base_speed = obstacle_speed
		obstacle_spawned.emit(obstacle)

func spawn_difficulty_pattern(difficulty: String, start_position: Vector2, spacing: float) -> void:
	# Spawn obstacles based on difficulty
	ObstacleFactory.create_difficulty_pattern(difficulty, start_position, spacing, obstacle_container)

func start_spawning() -> void:
	is_spawning = true
	spawn_timer = 0.0
	next_spawn_time = randf_range(spawn_timer_min, spawn_timer_max)

func stop_spawning() -> void:
	is_spawning = false

func clear_obstacles() -> void:
	if obstacle_container:
		for child in obstacle_container.get_children():
			child.queue_free()

func set_spawn_rate(min_time: float, max_time: float) -> void:
	spawn_timer_min = min_time
	spawn_timer_max = max_time

func set_obstacle_speed(speed: float) -> void:
	obstacle_speed = speed
