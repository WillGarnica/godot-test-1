class_name ButtonCommand
extends RefCounted
## Abstract base class for button commands
## Implements Command Pattern to eliminate code duplication

func execute() -> void:
	push_error("ButtonCommand.execute() must be overridden")

func get_description() -> String:
	return "Base Button Command"
