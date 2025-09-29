class_name SystemInitializer
extends Node
## Initializes and registers all system nodes
## Ensures proper startup order and dependency resolution

func _ready() -> void:
	# Initialize in proper order
	call_deferred("_initialize_systems")

func _initialize_systems() -> void:
	print("INFO: Starting system initialization...")
	
	# Step 1: Register core nodes
	_register_core_nodes()
	
	# Step 2: Register game nodes
	_register_game_nodes()
	
	# Step 3: Register UI nodes
	_register_ui_nodes()
	
	# Step 4: Validate system integrity
	_validate_systems()
	
	print("INFO: System initialization complete!")

func _register_core_nodes() -> void:
	# Register EventBus
	var eventbus = get_node_or_null("../EventBus")
	if eventbus and NodeRegistry.instance:
		NodeRegistry.instance.register_node("eventbus", eventbus)
	
	# Register NodeRegistry itself
	if NodeRegistry.instance:
		NodeRegistry.instance.register_node("node_registry", NodeRegistry.instance)
	
	# Register this initializer
	if NodeRegistry.instance:
		NodeRegistry.instance.register_node("system_initializer", self)

func _register_game_nodes() -> void:
	# Register Player
	var player = get_tree().get_first_node_in_group("player")
	if player and NodeRegistry.instance:
		NodeRegistry.instance.register_node("player", player)
	
	# Register ObstacleContainer
	var obstacle_container = get_tree().get_first_node_in_group("obstacle_container")
	if obstacle_container and NodeRegistry.instance:
		NodeRegistry.instance.register_node("obstacle_container", obstacle_container)
	
	# Register GameManager
	var game_manager = get_node_or_null("../GameManager")
	if game_manager and NodeRegistry.instance:
		NodeRegistry.instance.register_node("game_manager", game_manager)
	
	# Register ScoreManager
	var score_manager = get_node_or_null("../GameManager/ScoreManager")
	if score_manager and NodeRegistry.instance:
		NodeRegistry.instance.register_node("score_manager", score_manager)

func _register_ui_nodes() -> void:
	# Register UIManager
	var ui_manager = get_tree().get_first_node_in_group("ui_manager")
	if ui_manager and NodeRegistry.instance:
		NodeRegistry.instance.register_node("ui_manager", ui_manager)
	
	# Register DebugManager
	var debug_manager = get_tree().get_first_node_in_group("debug_manager")
	if debug_manager and NodeRegistry.instance:
		NodeRegistry.instance.register_node("debug_manager", debug_manager)

func _validate_systems() -> void:
	var critical_nodes = ["player", "obstacle_container", "game_manager", "score_manager"]
	var missing_nodes = []
	
	if NodeRegistry.instance:
		for node_key in critical_nodes:
			if not NodeRegistry.instance.is_registered(node_key):
				missing_nodes.append(node_key)
	
	if missing_nodes.size() > 0:
		print("ERROR: Critical nodes missing: %s" % missing_nodes)
	else:
		print("INFO: All critical nodes registered successfully")
	
	# Validate game configuration
	if not Validation.validate_positive_number(GameConfig.PLAYER_FLY_SPEED, "Player fly speed"):
		print("ERROR: Game configuration invalid")
	
	# Validate scene structure
	if not Validation.validate_node(get_tree().current_scene, "Scene root"):
		print("ERROR: Scene structure invalid")

# Public API for other systems to check if initialization is complete
func is_initialized() -> bool:
	return NodeRegistry.instance and NodeRegistry.instance.is_registered("system_initializer")
