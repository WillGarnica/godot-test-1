extends Control
## Options Menu UI Controller
## Handles options menu interactions including language selection

@onready var title_label: Label = $MainContainer/TitleContainer/TitleLabel
@onready var language_label: Label = $MainContainer/OptionsContainer/LanguageContainer/LanguageLabel
@onready var language_option: OptionButton = $MainContainer/OptionsContainer/LanguageContainer/LanguageOption
@onready var back_button: Button = $MainContainer/ButtonContainer/BackButton
@onready var options_container: VBoxContainer = $MainContainer/OptionsContainer

var button_tween: Tween
var settings: GameSettings

# Animation constants
const TITLE_ANIMATION_DURATION = 0.5
const BUTTON_ANIMATION_DELAY = 0.2
const OPTIONS_OFFSET = 30.0
const BUTTON_OFFSET = 20.0

func _ready() -> void:
	# Initialize settings
	settings = GameSettings.new()
	
	# Connect signals
	back_button.pressed.connect(_on_back_pressed)
	language_option.item_selected.connect(_on_language_selected)
	
	# Connect to language change events
	if EventBus.instance:
		EventBus.instance.language_changed.connect(_on_language_changed)
	
	# Setup language selector
	_setup_language_selector()
	
	# Setup initial animations
	_setup_initial_animations()
	
	# Update UI texts with translations
	_update_ui_texts()

func _setup_language_selector() -> void:
	# Clear existing items
	language_option.clear()
	
	# Add available languages with translations
	language_option.add_item(TranslationManager.translate("English"))
	language_option.add_item(TranslationManager.translate("Español"))
	
	# Set current selection based on TranslationManager
	var current_lang = TranslationManager.get_current_language()
	language_option.selected = current_lang

func _setup_initial_animations() -> void:
	# Animate title entrance
	title_label.modulate.a = 0.0
	title_label.scale = Vector2(0.5, 0.5)
	
	button_tween = create_tween()
	button_tween.tween_property(title_label, "modulate:a", 1.0, TITLE_ANIMATION_DURATION)
	button_tween.parallel().tween_property(title_label, "scale", Vector2(1.0, 1.0), TITLE_ANIMATION_DURATION)
	button_tween.tween_callback(_animate_options)

func _animate_options() -> void:
	# Animate options container
	options_container.modulate.a = 0.0
	var initial_y = options_container.position.y
	options_container.position.y += OPTIONS_OFFSET
	
	button_tween = create_tween()
	button_tween.tween_property(options_container, "modulate:a", 1.0, TITLE_ANIMATION_DURATION)
	button_tween.parallel().tween_property(options_container, "position:y", initial_y, TITLE_ANIMATION_DURATION)
	button_tween.tween_callback(_animate_back_button)

func _animate_back_button() -> void:
	# Animate back button
	back_button.modulate.a = 0.0
	var initial_y = back_button.position.y
	back_button.position.y += BUTTON_OFFSET
	
	button_tween = create_tween()
	button_tween.tween_property(back_button, "modulate:a", 1.0, TITLE_ANIMATION_DURATION)
	button_tween.parallel().tween_property(back_button, "position:y", initial_y, TITLE_ANIMATION_DURATION)

func _update_ui_texts() -> void:
	# Update texts with translations
	title_label.text = TranslationManager.translate("OPTIONS")
	language_label.text = TranslationManager.translate("Language:")
	back_button.text = TranslationManager.translate("BACK")
	
	# Update language option items
	_update_language_option_items()

func _update_language_option_items() -> void:
	# Update the text of language options
	if language_option.get_item_count() >= 2:
		language_option.set_item_text(0, TranslationManager.translate("English"))
		language_option.set_item_text(1, TranslationManager.translate("Español"))

func _on_language_changed(_language: int) -> void:
	# Update UI when language changes
	_update_ui_texts()
	# Update selected language in dropdown
	language_option.selected = _language

func _on_language_selected(index: int) -> void:
	# Change language when user selects a different option
	var selected_language: TranslationManager.Language = index as TranslationManager.Language
	TranslationManager.set_language(selected_language)

func _on_back_pressed() -> void:
	# Play button animation
	_play_button_animation(back_button)
	
	# Wait for animation
	await get_tree().create_timer(BUTTON_ANIMATION_DELAY).timeout
	
	# Go back to main menu
	get_tree().change_scene_to_file("res://src/scenes/ui/MainMenu.tscn")

func _play_button_animation(button: Button) -> void:
	# Button press animation
	button_tween = create_tween()
	button_tween.tween_property(button, "scale", Vector2(0.95, 0.95), 0.1)
	button_tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1)

func _input(event: InputEvent) -> void:
	# Handle escape key to go back
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			_on_back_pressed()

