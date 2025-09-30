extends Control
## Pause Menu UI Controller
## Handles pause menu interactions

@onready var resume_button: Button = $MenuContainer/ResumeButton
@onready var restart_button: Button = $MenuContainer/RestartButton
@onready var main_menu_button: Button = $MenuContainer/MainMenuButton

func _ready() -> void:
	# Connect button signals
	resume_button.pressed.connect(_on_resume_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	
	# Setup initial animation
	_setup_initial_animation()

func _setup_initial_animation() -> void:
	# Animate menu entrance
	modulate.a = 0.0
	scale = Vector2(0.8, 0.8)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	tween.parallel().tween_property(self, "scale", Vector2(1.0, 1.0), 0.3)

func _on_resume_pressed() -> void:
	_play_button_animation(resume_button)
	await get_tree().create_timer(0.2).timeout
	_resume_game()

func _on_restart_pressed() -> void:
	_play_button_animation(restart_button)
	await get_tree().create_timer(0.2).timeout
	_restart_game()

func _on_main_menu_pressed() -> void:
	_play_button_animation(main_menu_button)
	await get_tree().create_timer(0.2).timeout
	_go_to_main_menu()

func _play_button_animation(button: Button) -> void:
	# Button press animation
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(0.95, 0.95), 0.1)
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1)

func _resume_game() -> void:
	print("Resuming game...")
	EventBus.emit_game_resumed()
	get_tree().paused = false
	queue_free()

func _restart_game() -> void:
	print("Restarting game...")
	EventBus.emit_game_restarted()
	get_tree().paused = false
	# Game will restart automatically

func _go_to_main_menu() -> void:
	print("Going to main menu...")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/scenes/ui/MainMenu.tscn")

func _input(event: InputEvent) -> void:
	# Handle escape key to resume
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			_on_resume_pressed()
