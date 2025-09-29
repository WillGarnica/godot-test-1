extends Node2D
## Visualizes screen boundaries for debugging
## Shows where the player can and cannot move

@export var show_boundaries: bool = false
@export var boundary_color: Color = Color(1, 0, 0, 0.5)  # Semi-transparent red
@export var boundary_thickness: float = 3.0

var top_line: Line2D
var bottom_line: Line2D
var player: Node2D

func _ready() -> void:
	if not show_boundaries:
		return
	
	# Find player
	player = get_tree().get_first_node_in_group("player")
	if not player:
		player = get_node("../Player")
	
	# Create boundary lines
	_create_boundary_lines()
	
	# Add to debug_manager group for easy access
	add_to_group("debug_manager")

func _create_boundary_lines() -> void:
	# Create top boundary line
	top_line = Line2D.new()
	top_line.width = boundary_thickness
	top_line.default_color = boundary_color
	add_child(top_line)
	
	# Create bottom boundary line
	bottom_line = Line2D.new()
	bottom_line.width = boundary_thickness
	bottom_line.default_color = boundary_color
	add_child(bottom_line)

func _process(_delta: float) -> void:
	if not show_boundaries or not player:
		return
	
	_update_boundary_lines()

func _update_boundary_lines() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	var top_limit = player.margin_top
	var bottom_limit = viewport_size.y - player.margin_bottom
	
	# Update top boundary line
	top_line.clear_points()
	top_line.add_point(Vector2(0, top_limit))
	top_line.add_point(Vector2(viewport_size.x, top_limit))
	
	# Update bottom boundary line
	bottom_line.clear_points()
	bottom_line.add_point(Vector2(0, bottom_limit))
	bottom_line.add_point(Vector2(viewport_size.x, bottom_limit))

func toggle_boundaries() -> void:
	show_boundaries = !show_boundaries
	visible = show_boundaries
	if show_boundaries:
		_create_boundary_lines()

# Input handling for debug controls
func _input(event: InputEvent) -> void:
	if not show_boundaries:
		return
	
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_B:
				toggle_boundaries()
