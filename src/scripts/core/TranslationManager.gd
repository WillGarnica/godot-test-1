extends Node
## Translation Manager for i18n support
## Handles language switching and provides translation utilities
## Note: This is an autoload singleton, accessed as TranslationManager

# Available languages
enum Language {
	ENGLISH,
	SPANISH
}

# Language codes mapping
const LANGUAGE_CODES = {
	Language.ENGLISH: "en",
	Language.SPANISH: "es"
}

# Spanish locale variants
const SPANISH_LOCALES = ["es", "es_ES", "es_MX", "es_AR", "es_CO", "es_CL", "es_PE", "es_VE"]

# Current language
var current_language: Language = Language.ENGLISH

func _ready() -> void:
	_load_translations()
	_setup_initial_language()

func _load_translations() -> void:
	# Load translation files
	var en_translation = load("res://src/data/translations/en.po")
	var es_translation = load("res://src/data/translations/es.po")
	
	if en_translation:
		TranslationServer.add_translation(en_translation)
	
	if es_translation:
		TranslationServer.add_translation(es_translation)

func _setup_initial_language() -> void:
	# Try to detect system language
	var system_lang = OS.get_locale_language()
	
	if system_lang in SPANISH_LOCALES:
		set_language(Language.SPANISH)
	else:
		set_language(Language.ENGLISH)

## Set the current language
func set_language(language: Language) -> void:
	current_language = language
	var locale = LANGUAGE_CODES[language]
	TranslationServer.set_locale(locale)
	
	# Emit signal to update UI
	EventBus.emit_language_changed(language as int)
	
	GameLogger.info("Language changed to: %s" % LANGUAGE_CODES[language], GameLogger.Category.SYSTEM)

## Get translated string
static func translate(key: String) -> String:
	return TranslationServer.translate(key)

## Get current language
func get_current_language() -> Language:
	return current_language

## Get available languages
func get_available_languages() -> Array[Language]:
	return [Language.ENGLISH, Language.SPANISH]

## Toggle between languages (useful for testing)
func toggle_language() -> void:
	if current_language == Language.ENGLISH:
		set_language(Language.SPANISH)
	else:
		set_language(Language.ENGLISH)
