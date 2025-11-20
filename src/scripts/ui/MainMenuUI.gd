extends Control
## Main Menu UI Controller
## Handles menu navigation and button interactions

@onready var play_button: Button = $MainContainer/ButtonContainer/PlayButton
@onready var options_button: Button = $MainContainer/ButtonContainer/OptionsButton
@onready var credits_button: Button = $MainContainer/ButtonContainer/CreditsButton
@onready var shop_icon: Button = $RightIcons/ShopIcon
@onready var trophy_icon: Button = $RightIcons/TrophyIcon
@onready var settings_icon: Button = $RightIcons/SettingsIcon
@onready var awesome_label: Label = $MainContainer/TitleContainer/AwesomeLabel
@onready var game_label: Label = $MainContainer/TitleContainer/GameLabel

var button_tween: Tween
var title_tween: Tween
var settings: GameSettings

# Command Pattern - Button commands
var play_command: ButtonCommand
var options_command: ButtonCommand
var credits_command: ButtonCommand
var shop_command: ButtonCommand
var achievements_command: ButtonCommand
var settings_command: ButtonCommand

func _ready() -> void:
	# Initialize settings
	settings = GameSettings.new()
	
	# Initialize commands
	_initialize_commands()
	
	# Connect button signals
	play_button.pressed.connect(_on_play_pressed)
	options_button.pressed.connect(_on_options_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	shop_icon.pressed.connect(_on_shop_pressed)
	trophy_icon.pressed.connect(_on_trophy_pressed)
	settings_icon.pressed.connect(_on_settings_pressed)
	
	# Connect to language change events
	if EventBus.instance:
		EventBus.instance.language_changed.connect(_on_language_changed)
	
	# Setup initial animations
	_setup_initial_animations()
	
	# Update UI texts with translations
	_update_ui_texts()
	
	# Connect to game events
	# Note: Using static functions instead of direct signal connection
	# EventBus.game_restarted.connect(_on_game_restarted)

func _initialize_commands() -> void:
	# Initialize all button commands
	play_command = PlayCommand.new(get_tree())
	options_command = OptionsCommand.new(get_tree())
	credits_command = CreditsCommand.new()
	shop_command = ShopCommand.new()
	achievements_command = AchievementsCommand.new()
	settings_command = SettingsCommand.new()

func _setup_initial_animations() -> void:
	# Animate title entrance
	awesome_label.modulate.a = 0.0
	awesome_label.scale = Vector2(settings.title_initial_scale, settings.title_initial_scale)
	game_label.modulate.a = 0.0
	game_label.scale = Vector2(settings.title_initial_scale, settings.title_initial_scale)
	
	title_tween = create_tween()
	title_tween.tween_property(awesome_label, "modulate:a", 1.0, settings.title_animation_duration)
	title_tween.parallel().tween_property(awesome_label, "scale", Vector2(1.0, 1.0), settings.title_animation_duration)
	title_tween.parallel().tween_property(game_label, "modulate:a", 1.0, settings.title_animation_duration)
	title_tween.parallel().tween_property(game_label, "scale", Vector2(1.0, 1.0), settings.title_animation_duration)
	title_tween.tween_callback(_animate_buttons)
	
	# Setup button hover effects
	_setup_button_hover_effects()

func _animate_buttons() -> void:
	# Animate buttons entrance
	var buttons = [play_button, options_button, credits_button]
	
	for i in range(buttons.size()):
		var button = buttons[i]
		button.modulate.a = 0.0
		button.position.y += settings.button_entrance_offset
		
		# Create tween with delay
		button_tween = create_tween()
		#button_tween.tween_delay(i * settings.button_entrance_delay)
		button_tween.tween_property(button, "modulate:a", 1.0, 0.5)
		button_tween.parallel().tween_property(button, "position:y", button.position.y - settings.button_entrance_offset, 0.5)

func _setup_button_hover_effects() -> void:
	# Add hover effects to all buttons
	var buttons = [play_button, options_button, credits_button, shop_icon, trophy_icon, settings_icon]
	
	for button in buttons:
		button.mouse_entered.connect(_on_button_hover.bind(button))
		button.mouse_exited.connect(_on_button_unhover.bind(button))

func _on_button_hover(button: Button) -> void:
	# Scale up and add glow effect
	button_tween = create_tween()
	button_tween.tween_property(button, "scale", Vector2(settings.button_hover_scale, settings.button_hover_scale), 0.2)
	button_tween.parallel().tween_property(button, "modulate", Color(settings.button_hover_brightness, settings.button_hover_brightness, settings.button_hover_brightness, 1.0), 0.2)

func _on_button_unhover(button: Button) -> void:
	# Scale back to normal
	button_tween = create_tween()
	button_tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.2)
	button_tween.parallel().tween_property(button, "modulate", Color.WHITE, 0.2)

func _on_play_pressed() -> void:
	_execute_button_command(play_button, play_command)

func _on_options_pressed() -> void:
	_execute_button_command(options_button, options_command)

func _on_credits_pressed() -> void:
	_execute_button_command(credits_button, credits_command)

func _on_shop_pressed() -> void:
	_execute_button_command(shop_icon, shop_command)

func _on_trophy_pressed() -> void:
	_execute_button_command(trophy_icon, achievements_command)

func _on_settings_pressed() -> void:
	_execute_button_command(settings_icon, settings_command)

func _execute_button_command(button: Button, command: ButtonCommand) -> void:
	# Play button animation
	_play_button_animation(button)
	
	# Wait for animation to complete
	await get_tree().create_timer(settings.button_animation_duration).timeout
	
	# Execute the command
	command.execute()

func _play_button_animation(button: Button) -> void:
	# Button press animation
	button_tween = create_tween()
	button_tween.tween_property(button, "scale", Vector2(settings.button_press_scale, settings.button_press_scale), 0.1)
	button_tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1)

func _on_game_restarted() -> void:
	# Reset menu state when game is restarted
	_setup_initial_animations()

func _update_ui_texts() -> void:
	# Update button texts with translations
	play_button.text = TranslationManager.translate("PLAY")
	options_button.text = TranslationManager.translate("OPTIONS")
	credits_button.text = TranslationManager.translate("CREDITS")
	# Update title labels separately
	awesome_label.text = TranslationManager.translate("AWESOME")
	game_label.text = TranslationManager.translate("GAME")

func _on_language_changed(_language: int) -> void:
	_update_ui_texts()

func _input(event: InputEvent) -> void:
	# Handle keyboard shortcuts
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ENTER, KEY_SPACE:
				_on_play_pressed()
			KEY_ESCAPE:
				get_tree().quit()
			KEY_O:
				_on_options_pressed()
			KEY_C:
				_on_credits_pressed()
			KEY_S:
				_on_shop_pressed()
			KEY_A:
				_on_trophy_pressed()
			KEY_F1:
				_on_settings_pressed()
