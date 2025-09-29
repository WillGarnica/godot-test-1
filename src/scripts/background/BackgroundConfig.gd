class_name BackgroundConfig
extends RefCounted
## Configuration for background layers

@export var scroll_speed: float = 100.0
@export var background_width: float = 800.0
@export var layer_count: int = 3

# Layer configurations
@export var layers: Array[BackgroundLayer] = []

class BackgroundLayer extends Resource:
	@export var name: String
	@export var height: float
	@export var color: Color
	@export var y_position: float
	
	func _init(layer_name: String = "", layer_height: float = 0.0, layer_color: Color = Color.WHITE, y_pos: float = 0.0):
		name = layer_name
		height = layer_height
		color = layer_color
		y_position = y_pos

static func get_default_config() -> BackgroundConfig:
	var config = BackgroundConfig.new()
	config.scroll_speed = 100.0
	config.background_width = 800.0
	config.layer_count = 3
	
	# Sky layer
	config.layers.append(BackgroundLayer.new(
		"Sky",
		200.0,
		Color(0.5, 0.8, 1, 1),
		0.0
	))
	
	# Ground layer
	config.layers.append(BackgroundLayer.new(
		"Ground",
		200.0,
		Color(0.3, 0.6, 0.3, 1),
		200.0
	))
	
	return config
