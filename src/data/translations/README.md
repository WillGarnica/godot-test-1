# Sistema de Internacionalización (i18n)

Este proyecto incluye soporte completo para múltiples idiomas usando el sistema nativo de traducción de Godot.

## Archivos de Traducción

Los archivos de traducción están en formato `.po` (Portable Object) ubicados en `src/data/translations/`:

- `en.po` - Inglés (idioma por defecto)
- `es.po` - Español

## Cómo Agregar Nuevas Traducciones

### 1. Agregar la clave en el código

Usa `TranslationManager.translate()` para obtener traducciones:

```gdscript
var text = TranslationManager.translate("MI_TEXTO")
```

### 2. Agregar traducciones en los archivos .po

**En `en.po`:**
```
msgid "MI_TEXTO"
msgstr "My Text"
```

**En `es.po`:**
```
msgid "MI_TEXTO"
msgstr "Mi Texto"
```

### 3. Para textos con parámetros

```gdscript
var score_text = TranslationManager.translate("Score: %d") % score_value
```

En los archivos `.po`:
```
msgid "Score: %d"
msgstr "Score: %d"  # en inglés
msgstr "Puntuación: %d"  # en español
```

## Cambiar Idioma en Tiempo de Ejecución

```gdscript
# Cambiar a español
TranslationManager.set_language(TranslationManager.Language.SPANISH)

# Cambiar a inglés
TranslationManager.set_language(TranslationManager.Language.ENGLISH)

# Obtener idioma actual
var current_lang = TranslationManager.get_current_language()
```

## Detección Automática

El sistema detecta automáticamente el idioma del sistema operativo al iniciar el juego. Si el idioma del sistema es español (o alguna variante), se carga español; de lo contrario, se usa inglés.

## Agregar Nuevos Idiomas

1. Crear un nuevo archivo `.po` en `src/data/translations/` (ej: `fr.po` para francés)
2. Agregar el código de idioma en `TranslationManager.gd`:
   ```gdscript
   enum Language {
       ENGLISH,
       SPANISH,
       FRENCH  # nuevo
   }
   
   const LANGUAGE_CODES = {
       Language.ENGLISH: "en",
       Language.SPANISH: "es",
       Language.FRENCH: "fr"  # nuevo
   }
   ```
3. Cargar la traducción en `_load_translations()`
4. Agregar el archivo en `project.godot` en la sección `[internationalization]`

## Mejores Prácticas

- Usa claves descriptivas y en mayúsculas para constantes de UI
- Mantén las claves en inglés para facilitar la identificación
- Agrupa traducciones relacionadas en los archivos `.po`
- No uses traducciones para nombres propios o términos técnicos que no requieren traducción
- Prueba todos los idiomas antes de publicar

