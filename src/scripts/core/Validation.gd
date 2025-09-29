class_name Validation
extends RefCounted
## Utility class for common validations

static func validate_node(node: Node, node_name: String = "Node") -> bool:
	if not node:
		push_error("%s is null" % node_name)
		return false
	if not node.is_inside_tree():
		push_error("%s is not in scene tree" % node_name)
		return false
	return true

static func validate_position(position: Vector2, min_x: float = -10000, max_x: float = 10000, 
							min_y: float = -10000, max_y: float = 10000) -> bool:
	if position.x < min_x or position.x > max_x:
		push_error("Position X %s is out of range [%s, %s]" % [position.x, min_x, max_x])
		return false
	if position.y < min_y or position.y > max_y:
		push_error("Position Y %s is out of range [%s, %s]" % [position.y, min_y, max_y])
		return false
	return true

static func validate_speed(speed: float, min_speed: float = 0.0, max_speed: float = 1000.0) -> bool:
	if speed < min_speed or speed > max_speed:
		push_error("Speed %s is out of range [%s, %s]" % [speed, min_speed, max_speed])
		return false
	return true

static func validate_obstacle_type(obstacle_type: ObstacleType.Type) -> bool:
	var valid_types = ObstacleType.Type.values()
	if obstacle_type not in valid_types:
		push_error("Invalid obstacle type: %s" % obstacle_type)
		return false
	return true

static func validate_difficulty(difficulty: String) -> bool:
	var valid_difficulties = ["easy", "medium", "hard"]
	if difficulty not in valid_difficulties:
		push_error("Invalid difficulty: %s. Must be one of: %s" % [difficulty, valid_difficulties])
		return false
	return true

static func validate_positive_number(value: float, name: String = "Value") -> bool:
	if value <= 0:
		push_error("%s must be positive, got: %s" % [name, value])
		return false
	return true

static func validate_non_negative_number(value: float, name: String = "Value") -> bool:
	if value < 0:
		push_error("%s must be non-negative, got: %s" % [name, value])
		return false
	return true
