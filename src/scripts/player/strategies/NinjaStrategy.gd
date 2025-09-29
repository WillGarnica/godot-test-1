class_name NinjaStrategy
extends PlayerStrategy
## Agile strategy with dodge ability

func _init(player_config: Dictionary, player_node: CharacterBody2D) -> void:
	super(player_config, player_node)

func _apply_base_movement(_delta: float) -> void:
	# Agile movement with dodge chance
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

func _handle_dodge_ability() -> void:
	if Input.is_action_just_pressed("ui_select") and is_special_ready:
		# Enhanced dodge for ninja - longer duration
		_trigger_enhanced_dodge()
		is_special_ready = false
		EventBus.emit_player_special_ability_used("dodge")

func _trigger_enhanced_dodge() -> void:
	# Make player temporarily invulnerable for longer
	player.set_collision_layer_value(1, false)  # Disable collision
	# Re-enable collision after longer duration
	await player.get_tree().create_timer(1.0).timeout
	player.set_collision_layer_value(1, true)   # Re-enable collision

func can_dodge_obstacle(obstacle: Area2D) -> bool:
	# Ninja has higher dodge chance
	var distance = player.global_position.distance_to(obstacle.global_position)
	var dodge_chance = config.dodge_chance + (randf() * 0.2)  # Add some randomness
	return distance < 120.0 and randf() < dodge_chance
