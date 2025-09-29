class_name PlayerType
extends RefCounted

## Player type definitions and configurations
## Similar to ObstacleType but for different player characters

enum Type {
	RUNNER,        # Basic runner - balanced stats
	FLYER,         # High flying, fast but fragile
	TANK,          # Slow but can take multiple hits
	NINJA,         # Agile, can dodge better
	MAGE,          # Can teleport occasionally
	SPEEDSTER      # Very fast but very fragile
}

# Configuration for each player type
static func get_config(type: Type) -> Dictionary:
	match type:
		Type.RUNNER:
			return {
				"name": "Runner",
				"description": "Balanced character with average stats",
				"fly_speed": 300.0,
				"health": 1,
				"max_health": 1,
				"dodge_chance": 0.0,
				"special_ability": "none",
				"special_cooldown": 0.0,
				"color": Color(0.2, 0.8, 0.2, 1),
				"size": Vector2(32, 32),
				"margin_top": 50.0,
				"margin_bottom": 50.0,
				"score_multiplier": 1.0
			}
		Type.FLYER:
			return {
				"name": "Flyer",
				"description": "High flying speed, fragile but fast",
				"fly_speed": 400.0,
				"health": 1,
				"max_health": 1,
				"dodge_chance": 0.0,
				"special_ability": "none",
				"special_cooldown": 0.0,
				"color": Color(0.2, 0.2, 1.0, 1),
				"size": Vector2(28, 28),
				"margin_top": 30.0,
				"margin_bottom": 30.0,
				"score_multiplier": 1.2
			}
		Type.TANK:
			return {
				"name": "Tank",
				"description": "Slow but can survive multiple hits",
				"fly_speed": 200.0,
				"health": 3,
				"max_health": 3,
				"dodge_chance": 0.0,
				"special_ability": "none",
				"special_cooldown": 0.0,
				"color": Color(0.8, 0.4, 0.2, 1),
				"size": Vector2(40, 40),
				"margin_top": 60.0,
				"margin_bottom": 60.0,
				"score_multiplier": 0.8
			}
		Type.NINJA:
			return {
				"name": "Ninja",
				"description": "Agile with dodge ability",
				"fly_speed": 350.0,
				"health": 1,
				"max_health": 1,
				"dodge_chance": 0.3,
				"special_ability": "dodge",
				"special_cooldown": 2.0,
				"color": Color(0.4, 0.4, 0.4, 1),
				"size": Vector2(30, 30),
				"margin_top": 40.0,
				"margin_bottom": 40.0,
				"score_multiplier": 1.1
			}
		Type.MAGE:
			return {
				"name": "Mage",
				"description": "Can teleport to avoid obstacles",
				"fly_speed": 280.0,
				"health": 1,
				"max_health": 1,
				"dodge_chance": 0.0,
				"special_ability": "teleport",
				"special_cooldown": 5.0,
				"color": Color(0.8, 0.2, 0.8, 1),
				"size": Vector2(32, 32),
				"margin_top": 50.0,
				"margin_bottom": 50.0,
				"score_multiplier": 1.3
			}
		Type.SPEEDSTER:
			return {
				"name": "Speedster",
				"description": "Extremely fast but very fragile",
				"fly_speed": 500.0,
				"health": 1,
				"max_health": 1,
				"dodge_chance": 0.0,
				"special_ability": "none",
				"special_cooldown": 0.0,
				"color": Color(1.0, 0.8, 0.2, 1),
				"size": Vector2(24, 24),
				"margin_top": 35.0,
				"margin_bottom": 35.0,
				"score_multiplier": 1.5
			}
		_:
			return get_config(Type.RUNNER)

# Get all available player types
static func get_all_types() -> Array[Type]:
	return Type.values()

# Get player type by name
static func get_type_by_name(name: String) -> Type:
	for type in Type.values():
		if get_config(type).name.to_lower() == name.to_lower():
			return type
	return Type.RUNNER

# Check if player type is valid
static func is_valid_type(type: Type) -> bool:
	return type in Type.values()
