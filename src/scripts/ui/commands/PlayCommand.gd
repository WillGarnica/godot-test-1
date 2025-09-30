class_name PlayCommand
extends ButtonCommand
## Command for starting the game

var scene_tree: SceneTree

func _init(tree: SceneTree = null) -> void:
	scene_tree = tree

func execute() -> void:
	print("Starting game...")
	EventBus.emit_game_started()
	
	# Use the provided scene tree or get it from the current scene
	var tree = scene_tree if scene_tree else Engine.get_main_loop() as SceneTree
	if tree:
		tree.change_scene_to_file("res://src/scenes/main/Main.tscn")
	else:
		print("ERROR: Could not get SceneTree for scene change")

func get_description() -> String:
	return "Start Game"
