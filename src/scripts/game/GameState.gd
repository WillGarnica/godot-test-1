class_name GameState
extends Node
## Manages game state and transitions

enum State {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

signal state_changed(new_state: State)
signal game_started
signal game_paused
signal game_resumed
signal game_over(final_score: int)

var current_state: State = State.MENU
var previous_state: State = State.MENU

@onready var player: Node2D = get_node("../Player")

func _ready() -> void:
	# Add to game_manager group for obstacle collision detection
	add_to_group("game_manager")

func change_state(new_state: State) -> void:
	if current_state == new_state:
		return
	
	previous_state = current_state
	current_state = new_state
	state_changed.emit(new_state)
	
	# Handle state-specific logic
	match new_state:
		State.PLAYING:
			_handle_playing_state()
		State.PAUSED:
			_handle_paused_state()
		State.GAME_OVER:
			_handle_game_over_state()

func _handle_playing_state() -> void:
	game_started.emit()
	EventBus.emit_game_started()
	get_tree().paused = false

func _handle_paused_state() -> void:
	game_paused.emit()
	get_tree().paused = true

func _handle_game_over_state() -> void:
	var final_score = get_final_score()
	game_over.emit(final_score)
	EventBus.emit_game_over(final_score)
	EventBus.emit_ui_game_over_shown(final_score)

func start_game() -> void:
	change_state(State.PLAYING)

func pause_game() -> void:
	if current_state == State.PLAYING:
		change_state(State.PAUSED)

func resume_game() -> void:
	if current_state == State.PAUSED:
		change_state(State.PLAYING)

func end_game() -> void:
	change_state(State.GAME_OVER)

func restart_game() -> void:
	# Reset player position
	if player:
		player.position = GameConfig.PLAYER_START_POSITION
	
	# Emit restart event - let other systems handle their own reset
	EventBus.emit_game_restarted()
	
	# Start new game
	change_state(State.PLAYING)

func player_hit_obstacle() -> void:
	if current_state != State.PLAYING:
		return
	
	end_game()

func get_final_score() -> int:
	var score_manager = get_tree().get_first_node_in_group("score_manager")
	if score_manager and score_manager.has_method("get_current_score"):
		return score_manager.get_current_score()
	return 0

func is_playing() -> bool:
	return current_state == State.PLAYING

func is_paused() -> bool:
	return current_state == State.PAUSED

func is_game_over() -> bool:
	return current_state == State.GAME_OVER
