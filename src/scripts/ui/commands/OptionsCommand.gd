class_name OptionsCommand
extends ButtonCommand
## Command for showing options menu

func execute() -> void:
	print("Showing options...")
	_show_coming_soon("Options")

func _show_coming_soon(feature: String) -> void:
	var message = "Coming Soon: %s" % feature
	print(message)

func get_description() -> String:
	return "Show Options"
