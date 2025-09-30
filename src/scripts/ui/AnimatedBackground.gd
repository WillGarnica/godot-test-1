extends Control
## Animated background for the main menu
## Creates a pleasant outdoor scene with moving clouds and trees

@onready var clouds: Node2D = $Clouds
@onready var trees: Node2D = $Trees
@onready var hills: Node2D = $Hills

var settings: GameSettings
var cloud_tween: Tween
var tree_tween: Tween
var hill_tween: Tween

func _ready() -> void:
	# Initialize settings
	settings = GameSettings.new()
	
	# Start background animations
	_start_cloud_animation()
	_start_tree_animation()
	_start_hill_animation()
	
	# Setup initial positions
	_setup_initial_positions()

func _setup_initial_positions() -> void:
	# Position clouds at different heights
	var cloud_children = clouds.get_children()
	for i in range(cloud_children.size()):
		var cloud = cloud_children[i]
		cloud.position.y = randf_range(-20, 20)
		cloud.position.x = i * settings.cloud_spacing + randf_range(-settings.cloud_random_range, settings.cloud_random_range)
	
	# Position trees at different heights
	var tree_children = trees.get_children()
	for i in range(0, tree_children.size(), 2):  # Skip every other (leaves)
		var tree = tree_children[i]
		tree.position.y = randf_range(-settings.tree_sway_range, settings.tree_sway_range)
	
	# Position hills at different heights
	var hill_children = hills.get_children()
	for i in range(hill_children.size()):
		var hill = hill_children[i]
		hill.position.y = randf_range(-settings.hill_parallax_range, settings.hill_parallax_range)

func _start_cloud_animation() -> void:
	# Animate clouds moving from right to left
	cloud_tween = create_tween()
	cloud_tween.set_loops()
	cloud_tween.tween_property(clouds, "position:x", -400.0, 20.0)
	cloud_tween.tween_callback(_reset_clouds_position)

func _reset_clouds_position() -> void:
	# Reset clouds to right side when they go off screen
	clouds.position.x = 0.0
	_start_cloud_animation()

func _start_tree_animation() -> void:
	# Animate trees swaying gently
	tree_tween = create_tween()
	tree_tween.set_loops()
	tree_tween.tween_property(trees, "rotation", 0.05, settings.tree_sway_speed)
	tree_tween.tween_property(trees, "rotation", -0.05, settings.tree_sway_speed)
	tree_tween.tween_property(trees, "rotation", 0.0, settings.tree_sway_speed)

func _start_hill_animation() -> void:
	# Animate hills with subtle parallax movement
	hill_tween = create_tween()
	hill_tween.set_loops()
	hill_tween.tween_property(hills, "position:x", -50.0, 30.0)
	hill_tween.tween_property(hills, "position:x", 0.0, 30.0)

func _process(delta: float) -> void:
	# Add subtle random movement to individual elements
	_add_random_movement(delta)

func _add_random_movement(delta: float) -> void:
	# Add subtle random movement to clouds
	var cloud_children = clouds.get_children()
	var current_time = Time.get_time_dict_from_system()
	var time_value = current_time["unix"] if "unix" in current_time else Time.get_unix_time_from_system()
	
	for cloud in cloud_children:
		cloud.position.y += sin(time_value * 0.5 + cloud.position.x * 0.01) * 0.5 * delta
	
	# Add subtle random movement to trees
	var tree_children = trees.get_children()
	for i in range(0, tree_children.size(), 2):  # Skip every other (leaves)
		var tree = tree_children[i]
		tree.position.y += sin(time_value * 0.3 + tree.position.x * 0.02) * 0.3 * delta

func _on_visibility_changed() -> void:
	# Pause/resume animations when visibility changes
	if visible:
		_start_cloud_animation()
		_start_tree_animation()
		_start_hill_animation()
	else:
		if cloud_tween:
			cloud_tween.kill()
		if tree_tween:
			tree_tween.kill()
		if hill_tween:
			hill_tween.kill()
