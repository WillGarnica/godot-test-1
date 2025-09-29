extends Node
## Test script to demonstrate different player types
## Attach this to a node in your scene to test player spawning and switching

# Import player factory
const PlayerFactory = preload("res://src/scripts/player/PlayerFactory.gd")

@export var test_container: Node2D
@export var spawn_position: Vector2 = Vector2(100, 300)

var current_player: CharacterBody2D
var player_types: Array[PlayerType.Type] = []
var current_type_index: int = 0

func _ready() -> void:
	# Get all player types
	player_types = PlayerType.Type.values()
	print("Available player types: ", player_types.size())
	
	# Create initial player
	_create_current_player()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				_switch_to_type(PlayerType.Type.RUNNER)
			KEY_2:
				_switch_to_type(PlayerType.Type.FLYER)
			KEY_3:
				_switch_to_type(PlayerType.Type.TANK)
			KEY_4:
				_switch_to_type(PlayerType.Type.NINJA)
			KEY_5:
				_switch_to_type(PlayerType.Type.MAGE)
			KEY_6:
				_switch_to_type(PlayerType.Type.SPEEDSTER)
			KEY_N:
				_switch_to_next_type()
			KEY_P:
				_switch_to_previous_type()
			KEY_R:
				_respawn_current_player()
			KEY_T:
				_test_team_spawn()
			KEY_H:
				_show_player_help()
			KEY_D:
				_damage_current_player()
			KEY_F1:
				_heal_current_player()
			KEY_SPACE:
				_use_special_ability()

func _create_current_player() -> void:
	if current_player:
		current_player.queue_free()
	
	if not test_container:
		print("ERROR: Test container not set!")
		return
	
	var player_type = player_types[current_type_index]
	current_player = PlayerFactory.create_player(player_type, spawn_position, test_container)
	
	print("Created player: %s" % PlayerType.Type.keys()[player_type])

func _switch_to_type(type: PlayerType.Type) -> void:
	current_type_index = player_types.find(type)
	if current_type_index == -1:
		current_type_index = 0
	
	_create_current_player()
	_show_player_info()

func _switch_to_next_type() -> void:
	current_type_index = (current_type_index + 1) % player_types.size()
	_create_current_player()
	_show_player_info()

func _switch_to_previous_type() -> void:
	current_type_index = (current_type_index - 1 + player_types.size()) % player_types.size()
	_create_current_player()
	_show_player_info()

func _respawn_current_player() -> void:
	if current_player:
		current_player.position = spawn_position
		current_player.reset()
		print("Player respawned at position: %s" % spawn_position)

func _test_team_spawn() -> void:
	if not test_container:
		return
	
	# Clear existing players
	for child in test_container.get_children():
		if child is CharacterBody2D:
			child.queue_free()
	
	# Spawn a balanced team
	var team = PlayerFactory.create_team("balanced", spawn_position, test_container)
	print("Spawned balanced team with %d players" % team.size())

func _show_player_help() -> void:
	print("=== PLAYER TESTER CONTROLS ===")
	print("1-6: Switch to specific player type")
	print("N: Next player type")
	print("P: Previous player type")
	print("R: Respawn current player")
	print("T: Test team spawn")
	print("H: Show this help")
	print("D: Damage current player")
	print("F1: Heal current player")
	print("SPACE: Use special ability")
	print("=============================")

func _damage_current_player() -> void:
	if current_player:
		var died = current_player.take_damage(1)
		print("Player took damage. Health: %d/%d. Died: %s" % [
			current_player.get_health(),
			current_player.get_config().max_health,
			died
		])

func _heal_current_player() -> void:
	if current_player:
		current_player.heal(1)
		print("Player healed. Health: %d/%d" % [
			current_player.get_health(),
			current_player.get_config().max_health
		])

func _use_special_ability() -> void:
	if current_player and current_player.is_special_ability_ready():
		print("Using special ability...")
		# The ability will be handled by the strategy
	else:
		print("Special ability not ready. Cooldown: %.1f%%" % (current_player.get_special_cooldown_progress() * 100))

func _show_player_info() -> void:
	if not current_player:
		return
	
	var config = current_player.get_config()
	var strategy = current_player.get_strategy()
	
	print("=== PLAYER INFO ===")
	print("Type: %s" % config.name)
	print("Description: %s" % config.description)
	print("Speed: %.1f" % config.fly_speed)
	print("Health: %d/%d" % [config.health, config.max_health])
	print("Special Ability: %s" % config.special_ability)
	print("Score Multiplier: %.1fx" % config.score_multiplier)
	print("Strategy: %s" % strategy.get_script().get_global_name() if strategy else "None")
	print("==================")

func _process(_delta: float) -> void:
	# Show player info periodically
	if int(Engine.get_process_frames()) % 300 == 0:  # Every 5 seconds at 60fps
		_show_player_info()

# Connect to player events for testing
func _on_player_health_changed(current_health: int, max_health: int) -> void:
	print("Player health changed: %d/%d" % [current_health, max_health])

func _on_player_special_ability_used(ability_name: String) -> void:
	print("Player used special ability: %s" % ability_name)

func _on_player_died() -> void:
	print("Player died!")

func _on_player_respawned() -> void:
	print("Player respawned!")
