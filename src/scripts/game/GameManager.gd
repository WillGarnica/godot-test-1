extends Node
## Main Game Manager - Coordinates all game systems
## Now much cleaner and focused on coordination rather than implementation

@onready var obstacle_spawner: ObstacleSpawner = $ObstacleSpawner
@onready var score_manager: ScoreManager = $ScoreManager
@onready var game_state: GameState = $GameState

func _ready() -> void:
	# Connect signals between systems
	_setup_signal_connections()
	
	# Start the game
	game_state.start_game()

func _setup_signal_connections() -> void:
	# Connect score manager to UI
	score_manager.score_updated.connect(_on_score_updated)
	score_manager.high_score_updated.connect(_on_high_score_updated)
	
	# Connect game state changes
	game_state.state_changed.connect(_on_state_changed)
	game_state.game_started.connect(_on_game_started)
	game_state.game_over.connect(_on_game_over)
	
	# Connect obstacle spawner
	obstacle_spawner.obstacle_spawned.connect(_on_obstacle_spawned)
	
	# Connect to EventBus for decoupled communication
	_connect_to_eventbus()

func _on_score_updated(new_score: int) -> void:
	# Update UI with new score
	get_tree().call_group("ui_manager", "update_score", new_score)

func _on_high_score_updated(new_high_score: int) -> void:
	# Update UI with new high score
	get_tree().call_group("ui_manager", "update_high_score", new_high_score)

func _on_state_changed(new_state: GameState.State) -> void:
	match new_state:
		GameState.State.PLAYING:
			obstacle_spawner.start_spawning()
			score_manager.start_scoring()
		GameState.State.PAUSED:
			obstacle_spawner.stop_spawning()
			score_manager.stop_scoring()
		GameState.State.GAME_OVER:
			obstacle_spawner.stop_spawning()
			score_manager.stop_scoring()

func _on_game_started() -> void:
	print("Game started!")

func _on_game_over(final_score: int) -> void:
	print("Game Over! Final Score: ", final_score)

func _on_obstacle_spawned(_obstacle: Area2D) -> void:
	# Optional: Add any obstacle-specific logic here
	pass

func _on_game_restarted() -> void:
	# Handle game restart - reset all systems
	obstacle_spawner.clear_obstacles()
	score_manager.reset_score()
	get_tree().call_group("ui_manager", "hide_game_over")

func _on_player_hit_obstacle() -> void:
	player_hit_obstacle()

func _connect_to_eventbus() -> void:
	# Connect to EventBus signals
	EventBus.instance.game_restarted.connect(_on_game_restarted)
	EventBus.instance.player_hit_obstacle.connect(_on_player_hit_obstacle)

# Public API methods for external systems
func start_game() -> void:
	game_state.start_game()

func pause_game() -> void:
	game_state.pause_game()

func resume_game() -> void:
	game_state.resume_game()

func restart_game() -> void:
	game_state.restart_game()

func player_hit_obstacle() -> void:
	game_state.player_hit_obstacle()

# Difficulty management
func set_difficulty(difficulty: String) -> void:
	match difficulty:
		"easy":
			obstacle_spawner.set_spawn_rate(2.0, 4.0)
			obstacle_spawner.set_obstacle_speed(150.0)
		"medium":
			obstacle_spawner.set_spawn_rate(1.0, 3.0)
			obstacle_spawner.set_obstacle_speed(200.0)
		"hard":
			obstacle_spawner.set_spawn_rate(0.5, 2.0)
			obstacle_spawner.set_obstacle_speed(250.0)

# Utility methods
func get_current_score() -> int:
	return score_manager.get_current_score()

func get_high_score() -> int:
	return score_manager.get_high_score()

func is_game_playing() -> bool:
	return game_state.is_playing()
