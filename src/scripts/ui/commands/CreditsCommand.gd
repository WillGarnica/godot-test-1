class_name CreditsCommand
extends ButtonCommand
## Command for showing credits

func execute() -> void:
	print("Showing credits...")
	_show_coming_soon("Credits")

func _show_coming_soon(feature: String) -> void:
	var message = "Coming Soon: %s" % feature
	print(message)

func get_description() -> String:
	return "Show Credits"
