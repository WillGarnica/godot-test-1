class_name MageStrategy
extends PlayerStrategy
## Mage strategy with teleport ability

func _init(player_config: Dictionary, player_node: CharacterBody2D) -> void:
	super(player_config, player_node)

func _apply_base_movement(_delta: float) -> void:
	# Standard movement for mage
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

func _handle_teleport_ability() -> void:
	if Input.is_action_just_pressed("ui_select") and is_special_ready:
		# Enhanced teleport for mage
		_trigger_enhanced_teleport()
		is_special_ready = false
		EventBus.emit_player_special_ability_used("teleport")

func _trigger_enhanced_teleport() -> void:
	# Teleport to a safe position with visual effect
	var viewport_size = player.get_viewport().get_visible_rect().size
	var safe_y = randf_range(config.margin_top, viewport_size.y - config.margin_bottom)
	
	# Add teleport effect (you can add particles here later)
	player.position.y = safe_y
	
	# Brief invulnerability after teleport
	player.set_collision_layer_value(1, false)
	await player.get_tree().create_timer(0.3).timeout
	player.set_collision_layer_value(1, true)
