class_name AchievementsCommand
extends ButtonCommand
## Command for showing achievements

func execute() -> void:
	print("Showing achievements...")
	_show_coming_soon("Achievements")

func _show_coming_soon(feature: String) -> void:
	var message = "Coming Soon: %s" % feature
	print(message)

func get_description() -> String:
	return "Show Achievements"
