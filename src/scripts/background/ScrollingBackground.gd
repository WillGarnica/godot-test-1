extends Node2D
## Scrolling background for endless runner
## Creates parallax effect with configurable background layers

var config: BackgroundConfig
@export var auto_scroll: bool = true

var background_instances: Array[Node2D] = []
var is_initialized: bool = false

func _ready() -> void:
	initialize_background()

func initialize_background() -> void:
	if is_initialized:
		return
	
	# Use default config if none provided
	if not config:
		config = BackgroundConfig.get_default_config()
	
	create_background_instances()
	is_initialized = true

func create_background_instances() -> void:
	# Create multiple background instances for seamless scrolling
	for i in range(config.layer_count):
		var bg = create_background_sprite()
		bg.position.x = i * config.background_width
		add_child(bg)
		background_instances.append(bg)

func create_background_sprite() -> Node2D:
	var bg = Node2D.new()
	
	# Create layers based on configuration
	for layer in config.layers:
		var rect = ColorRect.new()
		rect.size = Vector2(config.background_width, layer.height)
		rect.position = Vector2(0, layer.y_position)
		rect.color = layer.color
		bg.add_child(rect)
	
	return bg

func _process(delta: float) -> void:
	if not auto_scroll or not is_initialized:
		return
	
	# Move all background instances
	for bg in background_instances:
		bg.position.x -= config.scroll_speed * delta
		
		# Reset position when background goes off-screen
		if bg.position.x <= -config.background_width:
			bg.position.x += config.background_width * background_instances.size()

# Public API
func set_scroll_speed(speed: float) -> void:
	config.scroll_speed = speed

func set_auto_scroll(enabled: bool) -> void:
	auto_scroll = enabled

func pause_scrolling() -> void:
	auto_scroll = false

func resume_scrolling() -> void:
	auto_scroll = true

func reset_position() -> void:
	for i in range(background_instances.size()):
		background_instances[i].position.x = i * config.background_width