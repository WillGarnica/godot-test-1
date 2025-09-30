extends Node
## Test script to verify EventBus functionality

func _ready() -> void:
	# Test EventBus signals
	print("Testing EventBus...")
	
	# Test if EventBus signals exist
	if EventBus:
		print("EventBus found!")
		
		# Test signal emission
		EventBus.emit_game_started()
		EventBus.emit_game_paused()
		EventBus.emit_game_resumed()
		EventBus.emit_game_restarted()
		EventBus.emit_game_over(100)
		
		print("EventBus test completed successfully!")
	else:
		print("ERROR: EventBus not found!")
