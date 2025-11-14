class_name OptionsCommand
extends ButtonCommand
## Command for showing options menu

var scene_tree: SceneTree

func _init(tree: SceneTree = null) -> void:
	scene_tree = tree

func execute() -> void:
	print("Showing options...")
	# Use the provided scene tree or get it from the current scene
	var tree = scene_tree if scene_tree else Engine.get_main_loop() as SceneTree
	if tree:
		tree.change_scene_to_file("res://src/scenes/ui/OptionsMenu.tscn")
	else:
		print("ERROR: Could not get SceneTree for scene change")

func get_description() -> String:
	return "Show Options"
