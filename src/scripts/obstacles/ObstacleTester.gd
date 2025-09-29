extends Node
## Test script to demonstrate different obstacle types
## Attach this to a node in your scene to test obstacle spawning

@export var test_container: Node2D
@export var spawn_interval: float = 2.0

var spawn_timer: float = 0.0
var obstacle_types: Array[ObstacleType.Type] = []

func _ready() -> void:
	# Get all obstacle types
	obstacle_types = ObstacleType.Type.values()
	print("Available obstacle types: ", obstacle_types.size())

func _process(delta: float) -> void:
	spawn_timer += delta
	
	if spawn_timer >= spawn_interval:
		# Test different spawning methods
		_test_random_spawn()
		spawn_timer = 0.0

func _test_random_spawn() -> void:
	if not test_container:
		return
	
	var viewport_size = get_viewport().get_visible_rect().size
	var spawn_position = Vector2(viewport_size.x + 50, randf_range(100, viewport_size.y - 100))
	
	# Create random obstacle
	var _obstacle = ObstacleFactory.create_random_obstacle(spawn_position, test_container)
	print("Spawned obstacle type: ", ObstacleType.Type.keys()[_obstacle.obstacle_type])

func _test_specific_type(type: ObstacleType.Type) -> void:
	if not test_container:
		return
	
	var viewport_size = get_viewport().get_visible_rect().size
	var spawn_position = Vector2(viewport_size.x + 50, viewport_size.y - 100)
	
	var _obstacle = ObstacleFactory.create_obstacle(type, spawn_position, test_container)
	print("Spawned specific obstacle: ", ObstacleType.Type.keys()[type])

func _test_pattern_spawn() -> void:
	if not test_container:
		return
	
	var viewport_size = get_viewport().get_visible_rect().size
	var start_position = Vector2(viewport_size.x + 50, viewport_size.y - 100)
	
	# Test different difficulty patterns
	var difficulties = ["easy", "medium", "hard"]
	var difficulty = difficulties[randi() % difficulties.size()]
	
	ObstacleFactory.create_difficulty_pattern(difficulty, start_position, 80.0, test_container)
	print("Spawned difficulty pattern: ", difficulty)

# Input handling for testing
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				_test_specific_type(ObstacleType.Type.STATIC_BOX)
			KEY_2:
				_test_specific_type(ObstacleType.Type.MOVING_BOX)
			KEY_3:
				_test_specific_type(ObstacleType.Type.SPIKE)
			KEY_4:
				_test_specific_type(ObstacleType.Type.BOUNCING_BALL)
			KEY_5:
				_test_specific_type(ObstacleType.Type.FALLING_ROCK)
			KEY_6:
				_test_specific_type(ObstacleType.Type.ROTATING_SAW)
			KEY_7:
				_test_specific_type(ObstacleType.Type.FLYING_BIRD)
			KEY_8:
				_test_specific_type(ObstacleType.Type.SLIDING_PLATFORM)
			KEY_P:
				_test_pattern_spawn()
			KEY_R:
				_test_random_spawn()
