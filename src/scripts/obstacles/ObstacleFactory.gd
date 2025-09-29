class_name ObstacleFactory
extends RefCounted

## Factory class for creating different types of obstacles
## Handles instantiation and configuration of obstacles

static func create_obstacle(type: ObstacleType.Type, position: Vector2, parent: Node) -> Area2D:
	# Load the obstacle scene
	var obstacle_scene = preload("res://src/scenes/obstacles/Obstacle.tscn")
	var obstacle = obstacle_scene.instantiate() as Area2D
	
	# Set the obstacle type
	obstacle.obstacle_type = type
	obstacle.position = position
	
	# Add to parent
	parent.add_child(obstacle)
	
	return obstacle

static func create_random_obstacle(position: Vector2, parent: Node) -> Area2D:
	# Get all available obstacle types
	var types = ObstacleType.Type.values()
	var random_type = types[randi() % types.size()]
	
	return create_obstacle(random_type, position, parent)

static func create_obstacle_sequence(positions: Array[Vector2], parent: Node) -> Array[Area2D]:
	# Create a sequence of obstacles at given positions
	var obstacles: Array[Area2D] = []
	
	for pos in positions:
		var obstacle = create_random_obstacle(pos, parent)
		obstacles.append(obstacle)
	
	return obstacles

static func create_obstacle_pattern(pattern: Array[ObstacleType.Type], start_position: Vector2, spacing: float, parent: Node) -> Array[Area2D]:
	# Create a specific pattern of obstacles
	var obstacles: Array[Area2D] = []
	
	for i in range(pattern.size()):
		var pos = start_position + Vector2(i * spacing, 0)
		var obstacle = create_obstacle(pattern[i], pos, parent)
		obstacles.append(obstacle)
	
	return obstacles

# Predefined obstacle patterns for different difficulty levels
static func get_easy_pattern() -> Array[ObstacleType.Type]:
	return [
		ObstacleType.Type.STATIC_BOX,
		ObstacleType.Type.STATIC_BOX,
		ObstacleType.Type.SPIKE
	]

static func get_medium_pattern() -> Array[ObstacleType.Type]:
	return [
		ObstacleType.Type.MOVING_BOX,
		ObstacleType.Type.BOUNCING_BALL,
		ObstacleType.Type.SPIKE,
		ObstacleType.Type.FLYING_BIRD
	]

static func get_hard_pattern() -> Array[ObstacleType.Type]:
	return [
		ObstacleType.Type.ROTATING_SAW,
		ObstacleType.Type.FALLING_ROCK,
		ObstacleType.Type.BOUNCING_BALL,
		ObstacleType.Type.FLYING_BIRD,
		ObstacleType.Type.SLIDING_PLATFORM
	]

static func create_difficulty_pattern(difficulty: String, start_position: Vector2, spacing: float, parent: Node) -> Array[Area2D]:
	var pattern: Array[ObstacleType.Type] = []
	
	match difficulty:
		"easy":
			pattern = get_easy_pattern()
		"medium":
			pattern = get_medium_pattern()
		"hard":
			pattern = get_hard_pattern()
		_:
			pattern = get_easy_pattern()
	
	return create_obstacle_pattern(pattern, start_position, spacing, parent)
