class_name MageStrategy
extends PlayerStrategy
## Mage strategy with teleport ability

func _init(player_config: Dictionary, player_node: CharacterBody2D) -> void:
	super(player_config, player_node)

func _apply_base_movement(_delta: float) -> void:
	# Standard movement for mage - horizontal now
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

func _handle_teleport_ability() -> void:
	if Input.is_action_just_pressed("ui_select") and is_special_ready:
		# Enhanced teleport for mage
		_trigger_enhanced_teleport()
		is_special_ready = false
		EventBus.emit_player_special_ability_used("teleport")

func _trigger_enhanced_teleport() -> void:
	# Teleport to a safe horizontal position with visual effect
	var viewport_size = player.get_viewport().get_visible_rect().size
	var margin_left = config.margin_left if config.has("margin_left") else GameConfig.PLAYER_MARGIN_LEFT
	var margin_right = config.margin_right if config.has("margin_right") else GameConfig.PLAYER_MARGIN_RIGHT
	var safe_x = randf_range(margin_left, viewport_size.x - margin_right)
	
	# Add teleport effect (you can add particles here later)
	player.position.x = safe_x
	
	# Brief invulnerability after teleport
	player.set_collision_layer_value(1, false)
	await player.get_tree().create_timer(0.3).timeout
	player.set_collision_layer_value(1, true)
