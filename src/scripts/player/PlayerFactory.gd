class_name PlayerFactory
extends RefCounted
## Factory class for creating different types of players
## Now uses Builder Pattern for more flexible player creation

static func create_player(type: PlayerType.Type, position: Vector2, parent: Node) -> CharacterBody2D:
	# Use Builder Pattern for cleaner player creation
	return PlayerBuilder.new() \
		.set_type(type) \
		.set_position(position) \
		.set_parent(parent) \
		.build()

static func create_random_player(position: Vector2, parent: Node) -> CharacterBody2D:
	# Use Builder Pattern for random player creation
	return PlayerBuilder.new() \
		.create_random() \
		.set_position(position) \
		.set_parent(parent) \
		.build()

static func create_player_by_name(name: String, position: Vector2, parent: Node) -> CharacterBody2D:
	# Create player by name
	var type = PlayerType.get_type_by_name(name)
	return create_player(type, position, parent)

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
		# Use Builder Pattern for team creation
		var player = PlayerBuilder.new() \
			.set_type(team_types[i]) \
			.set_position(pos) \
			.set_parent(parent) \
			.build()
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
