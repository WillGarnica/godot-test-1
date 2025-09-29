class_name SpeedsterStrategy
extends PlayerStrategy
## Extremely fast but fragile strategy

func _init(player_config: Dictionary, player_node: CharacterBody2D) -> void:
	super(player_config, player_node)

func _apply_base_movement(_delta: float) -> void:
	# Very fast movement with tight controls
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_accept"):
		velocity.y = -config.fly_speed
	elif Input.is_action_pressed("ui_down"):
		velocity.y = config.fly_speed
	else:
		velocity.y = 0
	
	velocity.x = 0
	player.velocity = velocity
	player.move_and_slide()
	
	# Enforce tight screen bounds for speedster
	_enforce_speedster_bounds()

func _enforce_speedster_bounds() -> void:
	var viewport_size = player.get_viewport().get_visible_rect().size
	var top_limit = config.margin_top
	var bottom_limit = viewport_size.y - config.margin_bottom
	
	player.position.y = clamp(player.position.y, top_limit, bottom_limit)
	
	# Stop movement at boundaries
	if player.position.y <= top_limit and player.velocity.y < 0:
		player.velocity.y = 0
	elif player.position.y >= bottom_limit and player.velocity.y > 0:
		player.velocity.y = 0

func take_damage(amount: int = 1) -> bool:
	# Speedster takes extra damage (more fragile)
	return super.take_damage(amount + 1)
