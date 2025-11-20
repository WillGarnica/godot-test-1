extends CharacterBody2D
## Player Controller using Strategy Pattern
## Handles different player types with their specific behaviors

@export var player_type: PlayerType.Type = PlayerType.Type.RUNNER

var strategy: PlayerStrategy
var config: Dictionary
var viewport_size: Vector2
var screen_bounds: Vector2

func _ready() -> void:
	# Validate player type
	if not PlayerType.is_valid_type(player_type):
		print("ERROR: Invalid player type: %s" % player_type)
		player_type = PlayerType.Type.RUNNER
	
	# Get configuration for this player type
	config = PlayerType.get_config(player_type)
	
	# Add to player group
	add_to_group("player")
	
	# Get viewport size
	viewport_size = get_viewport().get_visible_rect().size
	screen_bounds = Vector2(viewport_size.x, viewport_size.y)
	
	# Position player at bottom of screen, centered horizontally
	var margin_bottom = config.margin_bottom if config.has("margin_bottom") else 50.0
	position.y = viewport_size.y - margin_bottom
	position.x = viewport_size.x / 2.0  # Center horizontally
	
	# Initialize strategy will be set by PlayerFactory
	if GameConfig.DEBUG_LOG_LEVEL >= DebugManager.LogLevel.DEBUG:
		print("DEBUG: Player ready with type: %s at position: %s" % [config.name, position])

func _physics_process(delta: float) -> void:
	# Update viewport size in case of window resize
	viewport_size = get_viewport().get_visible_rect().size
	screen_bounds = Vector2(viewport_size.x, viewport_size.y)
	
	# Delegate movement to strategy
	if strategy:
		strategy.handle_movement(delta)
	else:
		# Fallback to basic movement if no strategy
		_handle_basic_movement(delta)
	
	# Apply screen boundaries
	enforce_screen_bounds()
	
	# Emit position change event
	EventBus.emit_player_position_changed(position)

func _handle_basic_movement(_delta: float) -> void:
	# Basic fallback movement - horizontal movement now
	var movement_velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		movement_velocity.x = -GameConfig.PLAYER_FLY_SPEED
	elif Input.is_action_pressed("ui_right"):
		movement_velocity.x = GameConfig.PLAYER_FLY_SPEED
	else:
		movement_velocity.x = 0
	
	movement_velocity.y = 0
	self.velocity = movement_velocity
	move_and_slide()

func set_strategy(new_strategy: PlayerStrategy) -> void:
	strategy = new_strategy
	if GameConfig.DEBUG_LOG_LEVEL >= DebugManager.LogLevel.DEBUG:
		print("DEBUG: Player strategy set to: %s" % config.name)

func get_strategy() -> PlayerStrategy:
	return strategy

func get_player_type() -> PlayerType.Type:
	return player_type

func get_config() -> Dictionary:
	return config

func enforce_screen_bounds() -> void:
	var limits = _get_screen_limits()
	
	# Clamp position to screen bounds (horizontal now)
	position.x = clamp(position.x, limits.left, limits.right)
	
	# If we hit a boundary, stop horizontal movement
	if position.x <= limits.left and velocity.x < 0:
		velocity.x = 0
	elif position.x >= limits.right and velocity.x > 0:
		velocity.x = 0

func _get_screen_limits() -> Dictionary:
	# Helper function to get screen limits (DRY principle)
	var left_limit = config.margin_left if config.has("margin_left") else GameConfig.PLAYER_MARGIN_LEFT
	var right_limit = screen_bounds.x - (config.margin_right if config.has("margin_right") else GameConfig.PLAYER_MARGIN_RIGHT)
	return {"left": left_limit, "right": right_limit}

func get_screen_bounds() -> Vector2:
	var limits = _get_screen_limits()
	return Vector2(limits.left, limits.right)

func is_at_left_boundary() -> bool:
	# Renamed from is_at_top_boundary - checks left boundary
	var limits = _get_screen_limits()
	return position.x <= limits.left

func is_at_right_boundary() -> bool:
	# Renamed from is_at_bottom_boundary - checks right boundary
	var limits = _get_screen_limits()
	return position.x >= limits.right

# Deprecated: Use is_at_left_boundary() instead
func is_at_top_boundary() -> bool:
	return is_at_left_boundary()

# Deprecated: Use is_at_right_boundary() instead
func is_at_bottom_boundary() -> bool:
	return is_at_right_boundary()

func get_health() -> int:
	if strategy:
		return strategy.get_health()
	return config.health

func take_damage(amount: int = 1) -> bool:
	if strategy:
		return strategy.take_damage(amount)
	else:
		config.health -= amount
		config.health = max(0, config.health)
		EventBus.emit_player_health_changed(config.health, config.max_health)
		return config.health <= 0

func heal(amount: int = 1) -> void:
	if strategy:
		strategy.heal(amount)
	else:
		config.health += amount
		config.health = min(config.health, config.max_health)
		EventBus.emit_player_health_changed(config.health, config.max_health)

func is_special_ability_ready() -> bool:
	if strategy:
		return strategy.is_special_ability_ready()
	return false

func get_special_cooldown_progress() -> float:
	if strategy:
		return strategy.get_special_cooldown_progress()
	return 1.0

func reset() -> void:
	if strategy:
		strategy.reset()
	else:
		config.health = config.max_health
