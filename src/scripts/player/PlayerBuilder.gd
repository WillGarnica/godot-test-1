class_name PlayerBuilder
extends RefCounted
## Builder Pattern implementation for creating players
## Eliminates switch statement and makes player creation more flexible

var _player: CharacterBody2D
var _type: PlayerType.Type
var _position: Vector2
var _parent: Node

# Import player strategies (using different names to avoid shadowing global classes)
const RunnerStrategyClass = preload("res://src/scripts/player/strategies/RunnerStrategy.gd")
const FlyerStrategyClass = preload("res://src/scripts/player/strategies/FlyerStrategy.gd")
const TankStrategyClass = preload("res://src/scripts/player/strategies/TankStrategy.gd")
const NinjaStrategyClass = preload("res://src/scripts/player/strategies/NinjaStrategy.gd")
const MageStrategyClass = preload("res://src/scripts/player/strategies/MageStrategy.gd")
const SpeedsterStrategyClass = preload("res://src/scripts/player/strategies/SpeedsterStrategy.gd")

func _init() -> void:
	# Initialize with default values
	_type = PlayerType.Type.RUNNER
	_position = Vector2.ZERO
	_parent = null

## Set the player type
func set_type(type: PlayerType.Type) -> PlayerBuilder:
	_type = type
	return self

## Set the player position
func set_position(pos: Vector2) -> PlayerBuilder:
	_position = pos
	return self

## Set the parent node
func set_parent(parent_node: Node) -> PlayerBuilder:
	_parent = parent_node
	return self

## Build and return the player
func build() -> CharacterBody2D:
	if not _parent:
		push_error("PlayerBuilder: Parent node must be set before building")
		return null
	
	# Load the player scene
	var player_scene = preload("res://src/scenes/player/Player.tscn")
	_player = player_scene.instantiate() as CharacterBody2D
	
	# Set the player type and position
	_player.player_type = _type
	_player.position = _position
	
	# Add to parent
	_parent.add_child(_player)
	
	# Initialize the player with its strategy
	_initialize_player_strategy(_player, _type)
	
	return _player

## Initialize player strategy based on type
func _initialize_player_strategy(player: CharacterBody2D, type: PlayerType.Type) -> void:
	# Get configuration for this player type
	var config = PlayerType.get_config(type)
	
	# Create appropriate strategy based on type
	var strategy: PlayerStrategy
	match type:
		PlayerType.Type.RUNNER:
			strategy = RunnerStrategyClass.new(config, player)
		PlayerType.Type.FLYER:
			strategy = FlyerStrategyClass.new(config, player)
		PlayerType.Type.TANK:
			strategy = TankStrategyClass.new(config, player)
		PlayerType.Type.NINJA:
			strategy = NinjaStrategyClass.new(config, player)
		PlayerType.Type.MAGE:
			strategy = MageStrategyClass.new(config, player)
		PlayerType.Type.SPEEDSTER:
			strategy = SpeedsterStrategyClass.new(config, player)
		_:
			strategy = RunnerStrategyClass.new(config, player)
	
	# Set the strategy on the player
	player.set_strategy(strategy)
	
	if GameConfig.DEBUG_LOG_LEVEL >= DebugManager.LogLevel.DEBUG:
		print("DEBUG: Player created with type: %s" % PlayerType.Type.keys()[type])

## Create a random player
func create_random() -> PlayerBuilder:
	var types = PlayerType.Type.values()
	var random_type = types[randi() % types.size()]
	return set_type(random_type)

## Create a balanced player (default stats)
func create_balanced() -> PlayerBuilder:
	return set_type(PlayerType.Type.RUNNER)

## Create a fast player
func create_fast() -> PlayerBuilder:
	return set_type(PlayerType.Type.FLYER)

## Create a tank player
func create_tank() -> PlayerBuilder:
	return set_type(PlayerType.Type.TANK)

## Create a ninja player
func create_ninja() -> PlayerBuilder:
	return set_type(PlayerType.Type.NINJA)

## Create a mage player
func create_mage() -> PlayerBuilder:
	return set_type(PlayerType.Type.MAGE)

## Create a speedster player
func create_speedster() -> PlayerBuilder:
	return set_type(PlayerType.Type.SPEEDSTER)
