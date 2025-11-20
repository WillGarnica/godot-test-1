class_name TankStrategy
extends PlayerStrategy
## Slow but durable strategy with multiple health

func _init(player_config: Dictionary, player_node: CharacterBody2D) -> void:
	super(player_config, player_node)

func _apply_base_movement(_delta: float) -> void:
	# Slower movement but more forgiving - horizontal now
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -config.fly_speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x = config.fly_speed
	else:
		velocity.x = 0
	
	velocity.y = 0
	player.velocity = velocity
	player.move_and_slide()
	
	# Enforce larger screen bounds for tank
	_enforce_tank_bounds()

func _enforce_tank_bounds() -> void:
	var viewport_size = player.get_viewport().get_visible_rect().size
	var left_limit = config.margin_left if config.has("margin_left") else GameConfig.PLAYER_MARGIN_LEFT
	var right_limit = viewport_size.x - (config.margin_right if config.has("margin_right") else GameConfig.PLAYER_MARGIN_RIGHT)
	
	player.position.x = clamp(player.position.x, left_limit, right_limit)
	
	# Stop movement at boundaries
	if player.position.x <= left_limit and player.velocity.x < 0:
		player.velocity.x = 0
	elif player.position.x >= right_limit and player.velocity.x > 0:
		player.velocity.x = 0

func take_damage(amount: int = 1) -> bool:
	# Tank takes less damage or has damage reduction
	var actual_damage = max(1, amount - 1)  # Reduce damage by 1
	return super.take_damage(actual_damage)
