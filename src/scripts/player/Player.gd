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
	
	# Initialize strategy will be set by PlayerFactory
	print("DEBUG: Player ready with type: %s" % config.name)

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
	# Basic fallback movement
	var movement_velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_accept"):
		movement_velocity.y = -GameConfig.PLAYER_FLY_SPEED
	elif Input.is_action_pressed("ui_down"):
		movement_velocity.y = GameConfig.PLAYER_FLY_SPEED
	else:
		movement_velocity.y = 0
	
	movement_velocity.x = 0
	self.velocity = movement_velocity
	move_and_slide()

func set_strategy(new_strategy: PlayerStrategy) -> void:
	strategy = new_strategy
	print("DEBUG: Player strategy set to: %s" % config.name)

func get_strategy() -> PlayerStrategy:
	return strategy

func get_player_type() -> PlayerType.Type:
	return player_type

func get_config() -> Dictionary:
	return config

func enforce_screen_bounds() -> void:
	# Use strategy's margins if available, otherwise use config
	var top_limit = config.margin_top
	var bottom_limit = screen_bounds.y - config.margin_bottom
	
	# Clamp position to screen bounds
	position.y = clamp(position.y, top_limit, bottom_limit)
	
	# If we hit a boundary, stop vertical movement
	if position.y <= top_limit and velocity.y < 0:
		velocity.y = 0
	elif position.y >= bottom_limit and velocity.y > 0:
		velocity.y = 0

func get_screen_bounds() -> Vector2:
	return Vector2(config.margin_top, screen_bounds.y - config.margin_bottom)

func is_at_top_boundary() -> bool:
	return position.y <= config.margin_top

func is_at_bottom_boundary() -> bool:
	return position.y >= screen_bounds.y - config.margin_bottom

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
