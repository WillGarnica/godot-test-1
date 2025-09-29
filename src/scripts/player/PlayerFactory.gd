class_name PlayerFactory
extends RefCounted
## Factory class for creating different types of players
## Handles instantiation and configuration of player strategies

# Import player strategies
const RunnerStrategy = preload("res://src/scripts/player/strategies/RunnerStrategy.gd")
const FlyerStrategy = preload("res://src/scripts/player/strategies/FlyerStrategy.gd")
const TankStrategy = preload("res://src/scripts/player/strategies/TankStrategy.gd")
const NinjaStrategy = preload("res://src/scripts/player/strategies/NinjaStrategy.gd")
const MageStrategy = preload("res://src/scripts/player/strategies/MageStrategy.gd")
const SpeedsterStrategy = preload("res://src/scripts/player/strategies/SpeedsterStrategy.gd")

static func create_player(type: PlayerType.Type, position: Vector2, parent: Node) -> CharacterBody2D:
	# Load the player scene
	var player_scene = preload("res://src/scenes/player/Player.tscn")
	var player = player_scene.instantiate() as CharacterBody2D
	
	# Set the player type and position
	player.player_type = type
	player.position = position
	
	# Add to parent
	parent.add_child(player)
	
	# Initialize the player with its strategy
	_initialize_player_strategy(player, type)
	
	return player

static func create_random_player(position: Vector2, parent: Node) -> CharacterBody2D:
	# Get all available player types
	var types = PlayerType.Type.values()
	var random_type = types[randi() % types.size()]
	
	return create_player(random_type, position, parent)

static func create_player_by_name(name: String, position: Vector2, parent: Node) -> CharacterBody2D:
	# Create player by name
	var type = PlayerType.get_type_by_name(name)
	return create_player(type, position, parent)

static func _initialize_player_strategy(player: CharacterBody2D, type: PlayerType.Type) -> void:
	# Get configuration for this player type
	var config = PlayerType.get_config(type)
	
	# Create appropriate strategy based on type
	var strategy: PlayerStrategy
	match type:
		PlayerType.Type.RUNNER:
			strategy = RunnerStrategy.new(config, player)
		PlayerType.Type.FLYER:
			strategy = FlyerStrategy.new(config, player)
		PlayerType.Type.TANK:
			strategy = TankStrategy.new(config, player)
		PlayerType.Type.NINJA:
			strategy = NinjaStrategy.new(config, player)
		PlayerType.Type.MAGE:
			strategy = MageStrategy.new(config, player)
		PlayerType.Type.SPEEDSTER:
			strategy = SpeedsterStrategy.new(config, player)
		_:
			strategy = RunnerStrategy.new(config, player)
	
	# Set the strategy on the player
	player.set_strategy(strategy)
	
	print("DEBUG: Player created with type: %s" % PlayerType.Type.keys()[type])

# Predefined player combinations for different game modes
static func get_balanced_team() -> Array[PlayerType.Type]:
	return [
		PlayerType.Type.RUNNER,
		PlayerType.Type.FLYER,
		PlayerType.Type.TANK
	]

static func get_speed_team() -> Array[PlayerType.Type]:
	return [
		PlayerType.Type.FLYER,
		PlayerType.Type.SPEEDSTER,
		PlayerType.Type.NINJA
	]

static func get_magic_team() -> Array[PlayerType.Type]:
	return [
		PlayerType.Type.MAGE,
		PlayerType.Type.NINJA,
		PlayerType.Type.RUNNER
	]

static func get_tank_team() -> Array[PlayerType.Type]:
	return [
		PlayerType.Type.TANK,
		PlayerType.Type.TANK,
		PlayerType.Type.RUNNER
	]

static func create_team(team_type: String, start_position: Vector2, parent: Node) -> Array[CharacterBody2D]:
	var team_types: Array[PlayerType.Type] = []
	
	match team_type:
		"balanced":
			team_types = get_balanced_team()
		"speed":
			team_types = get_speed_team()
		"magic":
			team_types = get_magic_team()
		"tank":
			team_types = get_tank_team()
		_:
			team_types = get_balanced_team()
	
	var players: Array[CharacterBody2D] = []
	var spacing = 100.0
	
	for i in range(team_types.size()):
		var pos = start_position + Vector2(i * spacing, 0)
		var player = create_player(team_types[i], pos, parent)
		players.append(player)
	
	return players

# Get player type statistics
static func get_player_stats(type: PlayerType.Type) -> Dictionary:
	var config = PlayerType.get_config(type)
	return {
		"name": config.name,
		"description": config.description,
		"fly_speed": config.fly_speed,
		"health": config.health,
		"special_ability": config.special_ability,
		"score_multiplier": config.score_multiplier
	}

# Compare two player types
static func compare_players(type1: PlayerType.Type, type2: PlayerType.Type) -> Dictionary:
	var stats1 = get_player_stats(type1)
	var stats2 = get_player_stats(type2)
	
	return {
		"speed_winner": type1 if stats1.fly_speed > stats2.fly_speed else type2,
		"health_winner": type1 if stats1.health > stats2.health else type2,
		"score_winner": type1 if stats1.score_multiplier > stats2.score_multiplier else type2
	}
