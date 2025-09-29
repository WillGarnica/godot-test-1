class_name ObstacleType
extends RefCounted

enum Type {
	STATIC_BOX,      # Static box
	MOVING_BOX,      # Box that moves vertically
	SPIKE,           # Static spike
	BOUNCING_BALL,   # Bouncing ball
	FALLING_ROCK,    # Falling rock
	ROTATING_SAW,    # Rotating saw
	FLYING_BIRD,     # Flying bird
	SLIDING_PLATFORM # Sliding platform
}

# Configuration for each obstacle type
static func get_config(type: Type) -> Dictionary:
	match type:
		Type.STATIC_BOX:
			return {
				"size": Vector2(40, 80),
				"speed": 0.0,
				"movement_type": "static",
				"color": Color(1, 0.2, 0.2, 1),
				"points_value": 10,
				"shape": "rectangle"
			}
		Type.MOVING_BOX:
			return {
				"size": Vector2(40, 80),
				"speed": 150.0,
				"movement_type": "vertical_bounce",
				"color": Color(0.2, 1, 0.2, 1),
				"points_value": 15,
				"shape": "rectangle"
			}
		Type.SPIKE:
			return {
				"size": Vector2(30, 30),
				"speed": 0.0,
				"movement_type": "static",
				"color": Color(0.5, 0.5, 0.5, 1),
				"points_value": 20,
				"shape": "triangle"
			}
		Type.BOUNCING_BALL:
			return {
				"size": Vector2(25, 25),
				"speed": 100.0,
				"movement_type": "bounce",
				"color": Color(1, 1, 0.2, 1),
				"points_value": 25,
				"shape": "circle"
			}
		Type.FALLING_ROCK:
			return {
				"size": Vector2(50, 50),
				"speed": 300.0,
				"movement_type": "falling",
				"color": Color(0.4, 0.2, 0.1, 1),
				"points_value": 30,
				"shape": "circle"
			}
		Type.ROTATING_SAW:
			return {
				"size": Vector2(60, 60),
				"speed": 200.0,
				"movement_type": "rotating",
				"color": Color(0.8, 0.8, 0.8, 1),
				"points_value": 35,
				"shape": "circle"
			}
		Type.FLYING_BIRD:
			return {
				"size": Vector2(35, 20),
				"speed": 180.0,
				"movement_type": "sine_wave",
				"color": Color(0.2, 0.8, 1, 1),
				"points_value": 40,
				"shape": "ellipse"
			}
		Type.SLIDING_PLATFORM:
			return {
				"size": Vector2(80, 20),
				"speed": 120.0,
				"movement_type": "horizontal_slide",
				"color": Color(0.6, 0.3, 0.1, 1),
				"points_value": 20,
				"shape": "rectangle"
			}
		_:
			return get_config(Type.STATIC_BOX)
