class_name PlayerStrategy
extends RefCounted
## Abstract base class for player movement strategies
## Each player type implements its own strategy

var config: Dictionary
var player: CharacterBody2D
var special_ability_timer: float = 0.0
var is_special_ready: bool = true

func _init(player_config: Dictionary, player_node: CharacterBody2D) -> void:
	config = player_config
	player = player_node

## Called every physics frame to handle movement
func handle_movement(delta: float) -> void:
	# Update special ability timer
	if not is_special_ready:
		special_ability_timer += delta
		if special_ability_timer >= config.special_cooldown:
			is_special_ready = true
			special_ability_timer = 0.0
	
	# Apply base movement
	_apply_base_movement(delta)
	
	# Apply special ability if available
	_apply_special_ability(delta)

## Apply the basic movement logic
func _apply_base_movement(_delta: float) -> void:
	# Default implementation - can be overridden
	var velocity = Vector2.ZERO
	
	# Handle horizontal movement (left/right)
	if Input.is_action_pressed("ui_left"):
		velocity.x = -config.fly_speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x = config.fly_speed
	else:
		velocity.x = 0
	
	# No vertical movement - player stays at bottom, obstacles fall from top
	velocity.y = 0
	
	# Apply movement
	player.velocity = velocity
	player.move_and_slide()

## Apply special abilities (override in subclasses)
func _apply_special_ability(_delta: float) -> void:
	match config.special_ability:
		"dodge":
			_handle_dodge_ability()
		"teleport":
			_handle_teleport_ability()
		_:
			pass

## Handle dodge ability (for Ninja)
func _handle_dodge_ability() -> void:
	if Input.is_action_just_pressed("ui_select") and is_special_ready:
		# Trigger dodge - make player temporarily invulnerable
		_trigger_dodge()
		is_special_ready = false
		EventBus.emit_player_special_ability_used("dodge")

## Handle teleport ability (for Mage)
func _handle_teleport_ability() -> void:
	if Input.is_action_just_pressed("ui_select") and is_special_ready:
		# Trigger teleport - move player to safe position
		_trigger_teleport()
		is_special_ready = false
		EventBus.emit_player_special_ability_used("teleport")

## Trigger dodge ability
func _trigger_dodge() -> void:
	# Make player temporarily invulnerable
	player.set_collision_layer_value(1, false)  # Disable collision
	# Re-enable collision after short duration
	await player.get_tree().create_timer(0.5).timeout
	player.set_collision_layer_value(1, true)   # Re-enable collision

## Trigger teleport ability
func _trigger_teleport() -> void:
	# Teleport to a random safe horizontal position
	var viewport_size = player.get_viewport().get_visible_rect().size
	var margin_left = config.margin_left if config.has("margin_left") else GameConfig.PLAYER_MARGIN_LEFT
	var margin_right = config.margin_right if config.has("margin_right") else GameConfig.PLAYER_MARGIN_RIGHT
	var safe_x = randf_range(margin_left, viewport_size.x - margin_right)
	player.position.x = safe_x

## Check if player can dodge an obstacle
func can_dodge_obstacle(obstacle: Area2D) -> bool:
	if config.special_ability == "dodge" and is_special_ready:
		# Check if obstacle is close enough to dodge
		var distance = player.global_position.distance_to(obstacle.global_position)
		return distance < 100.0
	return false

## Get current health
func get_health() -> int:
	return config.health

## Take damage
func take_damage(amount: int = 1) -> bool:
	config.health -= amount
	config.health = max(0, config.health)
	
	EventBus.emit_player_health_changed(config.health, config.max_health)
	
	return config.health <= 0

## Heal player
func heal(amount: int = 1) -> void:
	config.health += amount
	config.health = min(config.health, config.max_health)
	EventBus.emit_player_health_changed(config.health, config.max_health)

## Check if special ability is ready
func is_special_ability_ready() -> bool:
	return is_special_ready

## Get special ability cooldown progress (0.0 to 1.0)
func get_special_cooldown_progress() -> float:
	if is_special_ready:
		return 1.0
	return special_ability_timer / config.special_cooldown

## Reset strategy (for game restart)
func reset() -> void:
	config.health = config.max_health
	special_ability_timer = 0.0
	is_special_ready = true
