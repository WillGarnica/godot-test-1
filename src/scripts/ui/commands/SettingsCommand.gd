class_name SettingsCommand
extends ButtonCommand
## Command for showing settings

func execute() -> void:
	print("Showing settings...")
	_show_coming_soon("Settings")

func _show_coming_soon(feature: String) -> void:
	var message = "Coming Soon: %s" % feature
	print(message)

func get_description() -> String:
	return "Show Settings"
