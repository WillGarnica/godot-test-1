extends Node
## Test script to verify EventBus is working

func _ready() -> void:
	print("Testing EventBus...")
	
	# Test EventBus functions
	EventBus.emit_game_started()
	EventBus.emit_game_paused()
	EventBus.emit_game_resumed()
	EventBus.emit_game_restarted()
	EventBus.emit_game_over(100)
	
	print("EventBus test completed successfully!")
