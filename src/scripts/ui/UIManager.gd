extends Control
## UI Manager for Endless Runner
## Handles score display and game over screen

@onready var score_label: Label = $ScoreLabel
@onready var game_over_panel: Panel = $GameOverPanel
@onready var final_score_label: Label = $GameOverPanel/FinalScoreLabel
@onready var restart_button: Button = $GameOverPanel/RestartButton

func _ready() -> void:
	# Add to ui_manager group
	add_to_group("ui_manager")
	
	# Connect restart button
	restart_button.pressed.connect(_on_restart_button_pressed)
	
	# Connect to language change events
	if EventBus.instance:
		EventBus.instance.language_changed.connect(_on_language_changed)
	
	# Hide game over panel initially
	game_over_panel.visible = false
	
	# Update UI with current language
	_update_ui_texts()

func _update_ui_texts() -> void:
	# Update restart button text
	restart_button.text = TranslationManager.translate("Restart")

func update_score(new_score: int) -> void:
	score_label.text = TranslationManager.translate("Score: %d") % new_score

func show_game_over(final_score: int) -> void:
	game_over_panel.visible = true
	final_score_label.text = TranslationManager.translate("Final Score: %d") % final_score

func _on_language_changed(_language: int) -> void:
	_update_ui_texts()

func hide_game_over() -> void:
	if game_over_panel:
		game_over_panel.visible = false

func _on_restart_button_pressed() -> void:
	get_tree().call_group("game_manager", "restart_game")
