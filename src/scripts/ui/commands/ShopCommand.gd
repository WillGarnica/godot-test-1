class_name ShopCommand
extends ButtonCommand
## Command for showing shop

func execute() -> void:
	print("Showing shop...")
	_show_coming_soon("Shop")

func _show_coming_soon(feature: String) -> void:
	var message = "Coming Soon: %s" % feature
	print(message)

func get_description() -> String:
	return "Show Shop"
