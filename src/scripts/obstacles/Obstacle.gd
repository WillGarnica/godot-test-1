extends Area2D
## Obstacle for the endless runner game
## Supports multiple obstacle types with different behaviors

@export var obstacle_type: ObstacleType.Type = ObstacleType.Type.STATIC_BOX
@export var base_speed: float = 200.0

var config: Dictionary
var initial_position: Vector2
var time_elapsed: float = 0.0
var movement_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Validate obstacle type
	if not Validation.validate_obstacle_type(obstacle_type):
		print("ERROR: Invalid obstacle type: %s" % obstacle_type)
		queue_free()
		return
	
	# Get configuration for this obstacle type
	config = ObstacleType.get_config(obstacle_type)
	
	initial_position = position
	
	# Setup obstacle based on type
	_setup_obstacle()
	
	# Connect the body_entered signal to detect collision with player
	body_entered.connect(_on_body_entered)
	
	print("DEBUG: Obstacle created: %s" % ObstacleType.Type.keys()[obstacle_type])

func _setup_obstacle() -> void:
	# Set points value
	# Note: You might want to expose this in the config if needed
	
	# Setup visual representation based on shape
	_setup_visual()
	
	# Setup collision shape
	_setup_collision()

func _setup_visual() -> void:
	var sprite = get_node("ObstacleSprite") as ColorRect
	if sprite:
		sprite.color = config.color
		sprite.size = config.size
		sprite.position = -config.size / 2

func _setup_collision() -> void:
	var collision = get_node("ObstacleCollision") as CollisionShape2D
	if collision:
		match config.shape:
			"rectangle":
				var rect_shape = RectangleShape2D.new()
				rect_shape.size = config.size
				collision.shape = rect_shape
			"circle":
				var circle_shape = CircleShape2D.new()
				circle_shape.radius = config.size.x / 2
				collision.shape = circle_shape
			"triangle":
				# For triangle, we'll use a rectangle for now
				# You can implement a custom triangle shape if needed
				var rect_shape = RectangleShape2D.new()
				rect_shape.size = config.size
				collision.shape = rect_shape
			"ellipse":
				var circle_shape = CircleShape2D.new()
				circle_shape.radius = config.size.x / 2
				collision.shape = circle_shape

func _physics_process(delta: float) -> void:
	time_elapsed += delta
	
	# Apply movement based on type
	_apply_movement(delta)
	
	# Move obstacle from right to left (base movement)
	position.x -= base_speed * delta
	
	# Debug logging at configured interval (only when debug is enabled)
	if int(time_elapsed * 60) % GameConfig.DEBUG_OBSTACLE_MOVEMENT_INTERVAL == 0:
		print("DEBUG: Obstacle %s at position: %s, speed: %s" % [
			ObstacleType.Type.keys()[obstacle_type], position, base_speed
		])
	
	# Destroy obstacle when it goes off-screen
	if GameConfig.is_obstacle_off_screen(position):
		print("DEBUG: Obstacle destroyed at position: %s" % position)
		queue_free()

func _apply_movement(delta: float) -> void:
	match config.movement_type:
		"static":
			# No additional movement
			pass
		"vertical_bounce":
			# Bounce up and down
			movement_offset.y = sin(time_elapsed * 3.0) * 30.0
			position.y = initial_position.y + movement_offset.y
		"bounce":
			# Bounce in all directions
			movement_offset.x = sin(time_elapsed * 2.0) * 20.0
			movement_offset.y = cos(time_elapsed * 2.0) * 20.0
			position += movement_offset * delta
		"falling":
			# Fall down with gravity
			movement_offset.y += config.speed * delta
			position.y = initial_position.y + movement_offset.y
		"rotating":
			# Rotate around its center
			rotation += delta * 3.0
		"sine_wave":
			# Move in a sine wave pattern
			movement_offset.y = sin(time_elapsed * 2.0) * 40.0
			position.y = initial_position.y + movement_offset.y
		"horizontal_slide":
			# Slide horizontally
			movement_offset.x = sin(time_elapsed * 1.5) * 50.0
			position.x = initial_position.x + movement_offset.x

func _on_body_entered(body: Node2D) -> void:
	# Check if the body is the player
	if body.name == "Player":
		# Emit signal to game manager that player hit obstacle
		get_tree().call_group("game_manager", "player_hit_obstacle")
		# Destroy the obstacle
		queue_free()

func get_points_value() -> int:
	return config.points_value
