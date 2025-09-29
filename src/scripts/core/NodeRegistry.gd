class_name NodeRegistry
extends Node
## Centralized node reference system
## Eliminates fragile paths and improves performance

# Singleton instance
static var instance: NodeRegistry

# Node references cache
var _node_cache: Dictionary = {}

func _ready() -> void:
	instance = self

# Register nodes for easy access
func register_node(key: String, node: Node) -> void:
	if node:
		_node_cache[key] = node
		print("NodeRegistry: Registered '%s' -> %s" % [key, node.name])

func unregister_node(key: String) -> void:
	if key in _node_cache:
		_node_cache.erase(key)
		print("NodeRegistry: Unregistered '%s'" % key)

func get_registered_node(key: String) -> Node:
	if key in _node_cache:
		return _node_cache[key]
	
	print("NodeRegistry: Node '%s' not found!" % key)
	return null

# Convenience methods for common nodes
func get_player() -> Node2D:
	return get_registered_node("player") as Node2D

func get_obstacle_container() -> Node2D:
	return get_registered_node("obstacle_container") as Node2D

func get_ui_manager() -> Control:
	return get_registered_node("ui_manager") as Control

func get_game_manager() -> Node:
	return get_registered_node("game_manager") as Node

func get_score_manager() -> Node:
	return get_registered_node("score_manager") as Node

func get_debug_manager() -> Node:
	return get_registered_node("debug_manager") as Node

# Validation methods
func is_registered(key: String) -> bool:
	return key in _node_cache

func get_registered_keys() -> Array:
	return _node_cache.keys()

# Cleanup
func clear_cache() -> void:
	_node_cache.clear()
