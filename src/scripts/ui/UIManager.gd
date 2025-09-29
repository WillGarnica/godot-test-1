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
	
	# Hide game over panel initially
	game_over_panel.visible = false

func update_score(new_score: int) -> void:
	if score_label:
		score_label.text = "Score: " + str(new_score)

func show_game_over(final_score: int) -> void:
	if game_over_panel and final_score_label:
		game_over_panel.visible = true
		final_score_label.text = "Final Score: " + str(final_score)

func hide_game_over() -> void:
	if game_over_panel:
		game_over_panel.visible = false

func _on_restart_button_pressed() -> void:
	get_tree().call_group("game_manager", "restart_game")
