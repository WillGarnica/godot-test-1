class_name MenuManager
extends Node
## Centralized menu management system
## Handles navigation between different menu screens

signal menu_changed(menu_name: String)
signal game_started
signal game_paused
signal game_resumed

enum MenuType {
	MAIN_MENU,
	OPTIONS,
	CREDITS,
	SHOP,
	ACHIEVEMENTS,
	SETTINGS,
	PAUSE_MENU,
	GAME_OVER
}

var current_menu: MenuType = MenuType.MAIN_MENU
var menu_stack: Array[MenuType] = []
var menu_scenes: Dictionary = {}

func _ready() -> void:
	# Register menu scenes
	_register_menu_scenes()
	
	# Connect to game events
	# Note: Using static functions instead of direct signal connection
	# EventBus.game_started.connect(_on_game_started)
	# EventBus.game_paused.connect(_on_game_paused)
	# EventBus.game_resumed.connect(_on_game_resumed)
	# EventBus.game_over.connect(_on_game_over)

func _register_menu_scenes() -> void:
	# Register all menu scenes
	menu_scenes[MenuType.MAIN_MENU] = "res://src/scenes/ui/MainMenu.tscn"
	menu_scenes[MenuType.OPTIONS] = "res://src/scenes/ui/OptionsMenu.tscn"
	menu_scenes[MenuType.CREDITS] = "res://src/scenes/ui/CreditsMenu.tscn"
	menu_scenes[MenuType.SHOP] = "res://src/scenes/ui/ShopMenu.tscn"
	menu_scenes[MenuType.ACHIEVEMENTS] = "res://src/scenes/ui/AchievementsMenu.tscn"
	menu_scenes[MenuType.SETTINGS] = "res://src/scenes/ui/SettingsMenu.tscn"
	menu_scenes[MenuType.PAUSE_MENU] = "res://src/scenes/ui/PauseMenu.tscn"
	menu_scenes[MenuType.GAME_OVER] = "res://src/scenes/ui/GameOverMenu.tscn"

func show_menu(menu_type: MenuType, add_to_stack: bool = true) -> void:
	# Add current menu to stack if needed
	if add_to_stack and current_menu != menu_type:
		menu_stack.push_back(current_menu)
	
	# Change to new menu
	current_menu = menu_type
	var scene_path = menu_scenes.get(menu_type)
	
	if scene_path and ResourceLoader.exists(scene_path):
		get_tree().change_scene_to_file(scene_path)
		menu_changed.emit(MenuType.keys()[menu_type])
		print("Switched to menu: %s" % MenuType.keys()[menu_type])
	else:
		print("ERROR: Menu scene not found: %s" % MenuType.keys()[menu_type])

func go_back() -> void:
	# Go back to previous menu
	if menu_stack.size() > 0:
		var previous_menu = menu_stack.pop_back()
		show_menu(previous_menu, false)
	else:
		# If no previous menu, go to main menu
		show_menu(MenuType.MAIN_MENU, false)

func show_main_menu() -> void:
	# Clear menu stack and show main menu
	menu_stack.clear()
	show_menu(MenuType.MAIN_MENU, false)

func show_options() -> void:
	show_menu(MenuType.OPTIONS)

func show_credits() -> void:
	show_menu(MenuType.CREDITS)

func show_shop() -> void:
	show_menu(MenuType.SHOP)

func show_achievements() -> void:
	show_menu(MenuType.ACHIEVEMENTS)

func show_settings() -> void:
	show_menu(MenuType.SETTINGS)

func show_pause_menu() -> void:
	show_menu(MenuType.PAUSE_MENU)

func show_game_over(final_score: int) -> void:
	show_menu(MenuType.GAME_OVER)
	# Pass score to game over menu if needed
	EventBus.emit_ui_game_over_shown(final_score)

func start_game() -> void:
	# Clear menu stack and start game
	menu_stack.clear()
	EventBus.emit_game_started()
	game_started.emit()
	
	# Change to game scene
	get_tree().change_scene_to_file("res://src/scenes/main/Main.tscn")

func restart_game() -> void:
	# Restart the game
	EventBus.emit_game_restarted()
	start_game()

func quit_game() -> void:
	# Quit the game
	get_tree().quit()

func get_current_menu() -> MenuType:
	return current_menu

func is_in_menu() -> bool:
	return current_menu != MenuType.MAIN_MENU or menu_stack.size() > 0

func clear_menu_stack() -> void:
	menu_stack.clear()

# Event handlers
func _on_game_started() -> void:
	game_started.emit()

func _on_game_paused() -> void:
	show_pause_menu()
	game_paused.emit()

func _on_game_resumed() -> void:
	go_back()
	game_resumed.emit()

func _on_game_over(final_score: int) -> void:
	show_game_over(final_score)

# Input handling
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ESCAPE:
				_handle_escape_key()
			KEY_F1:
				show_settings()

func _handle_escape_key() -> void:
	# Handle escape key based on current menu
	match current_menu:
		MenuType.MAIN_MENU:
			quit_game()
		MenuType.PAUSE_MENU:
			# Resume game
			EventBus.emit_game_resumed()
		_:
			# Go back to previous menu
			go_back()
