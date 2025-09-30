extends Node
## Game initialization and scene management
## Handles the transition from menu to game and back

var menu_manager: MenuManager

func _ready() -> void:
	# Create and add menu manager to scene tree
	menu_manager = MenuManager.new()
	add_child(menu_manager)
	
	# Connect to menu events
	menu_manager.game_started.connect(_on_game_started)
	menu_manager.game_paused.connect(_on_game_paused)
	menu_manager.game_resumed.connect(_on_game_resumed)
	
	# Connect to game events
	# Note: Using static functions instead of direct signal connection
	# EventBus.game_over.connect(_on_game_over)
	# EventBus.game_restarted.connect(_on_game_restarted)

func _on_game_started() -> void:
	print("Game started from menu")
	# The MenuManager already handles scene transition

func _on_game_paused() -> void:
	print("Game paused")

func _on_game_resumed() -> void:
	print("Game resumed")

func _on_game_over(final_score: int) -> void:
	print("Game over with score: %d" % final_score)
	# MenuManager will handle showing game over screen

func _on_game_restarted() -> void:
	print("Game restarted")
	# MenuManager will handle restart

func get_menu_manager() -> MenuManager:
	return menu_manager
