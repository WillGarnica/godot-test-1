class_name ScoreManager
extends Node
## Handles score calculation and UI updates

signal score_updated(new_score: int)
signal high_score_updated(new_high_score: int)

@export var score_per_second: int = 10
@export var obstacle_bonus: int = 50
@export var survival_bonus: int = 100

var current_score: int = 0
var high_score: int = 0
var is_scoring: bool = true

func _ready() -> void:
	# Load high score from save file
	load_high_score()

func _process(delta: float) -> void:
	if not is_scoring:
		return
	
	# Update score based on time survived
	var time_score = int(delta * score_per_second)
	add_score(time_score)

func add_score(points: int) -> void:
	current_score += points
	score_updated.emit(current_score)
	
	# Check for new high score
	if current_score > high_score:
		high_score = current_score
		high_score_updated.emit(high_score)
		save_high_score()

func add_obstacle_bonus() -> void:
	add_score(obstacle_bonus)

func add_survival_bonus() -> void:
	add_score(survival_bonus)

func reset_score() -> void:
	current_score = 0
	score_updated.emit(current_score)

func start_scoring() -> void:
	is_scoring = true

func stop_scoring() -> void:
	is_scoring = false

func get_current_score() -> int:
	return current_score

func get_high_score() -> int:
	return high_score

func save_high_score() -> void:
	# Save high score to file
	var save_file = FileAccess.open("user://high_score.save", FileAccess.WRITE)
	if save_file:
		save_file.store_32(high_score)
		save_file.close()

func load_high_score() -> void:
	# Load high score from file
	var save_file = FileAccess.open("user://high_score.save", FileAccess.READ)
	if save_file:
		high_score = save_file.get_32()
		save_file.close()
		high_score_updated.emit(high_score)
