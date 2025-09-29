class_name GameLogger
extends Node
## Centralized logging system with levels and categories

# Singleton instance
static var instance: GameLogger

enum Level {
	DEBUG = 0,
	INFO = 1,
	WARNING = 2,
	ERROR = 3
}

enum Category {
	GAME,
	OBSTACLES,
	PLAYER,
	UI,
	INPUT,
	PERFORMANCE,
	SYSTEM
}

# Configuration
static var log_level: Level = Level.INFO
static var enable_debug: bool = false

func _ready() -> void:
	instance = self

# Simple logging functions
static func debug(message: String, category: Category = Category.GAME) -> void:
	if enable_debug:
		print("[DEBUG] [%s] %s" % [Category.keys()[category], message])

static func info(message: String, category: Category = Category.GAME) -> void:
	print("[INFO] [%s] %s" % [Category.keys()[category], message])

static func warning(message: String, category: Category = Category.GAME) -> void:
	print_rich("[color=yellow][WARNING] [%s] %s[/color]" % [Category.keys()[category], message])

static func error(message: String, category: Category = Category.GAME) -> void:
	print_rich("[color=red][ERROR] [%s] %s[/color]" % [Category.keys()[category], message])

# Configuration
static func set_debug_enabled(enabled: bool) -> void:
	enable_debug = enabled
