class_name RunnerStrategy
extends PlayerStrategy
## Basic runner strategy - balanced movement

func _init(player_config: Dictionary, player_node: CharacterBody2D) -> void:
	super(player_config, player_node)

func _apply_base_movement(_delta: float) -> void:
	# Standard movement with balanced speed - horizontal now
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
