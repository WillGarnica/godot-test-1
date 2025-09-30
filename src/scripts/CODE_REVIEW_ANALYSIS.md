# 🔍 Code Review Analysis - Godot Test 1

## 📊 **Resumen Ejecutivo**

He identificado **15+ code smells** y **8 oportunidades de refactorización** en el código que hemos desarrollado. El proyecto tiene una base sólida pero necesita mejoras significativas en arquitectura, mantenibilidad y rendimiento.

---

## 🚨 **Code Smells Identificados**

### 1. **MainMenuUI.gd - Violación DRY (Don't Repeat Yourself)**

**Problema**: Código duplicado en funciones de botones
```gdscript
func _on_play_pressed() -> void:
    _play_button_animation(play_button)
    await get_tree().create_timer(0.3).timeout
    _start_game()

func _on_options_pressed() -> void:
    _play_button_animation(options_button)
    await get_tree().create_timer(0.3).timeout
    _show_options()
```

**Impacto**: Mantenimiento difícil, propenso a errores

### 2. **EventBus.gd - God Class (Clase Dios)**

**Problema**: 155 líneas, 20+ señales, 15+ funciones estáticas
```gdscript
# Demasiadas responsabilidades en una sola clase
signal game_started
signal game_paused
signal game_resumed
signal game_over(final_score: int)
signal game_restarted
# ... 15+ señales más
```

**Impacto**: Violación del principio de responsabilidad única

### 3. **Player.gd - Métodos Largos**

**Problema**: `_physics_process()` hace demasiadas cosas
```gdscript
func _physics_process(delta: float) -> void:
    # Update viewport size in case of window resize
    viewport_size = get_viewport().get_visible_rect().size
    screen_bounds = Vector2(viewport_size.x, viewport_size.y)
    
    # Delegate movement to strategy
    if strategy:
        strategy.handle_movement(delta)
    else:
        _handle_basic_movement(delta)
    
    # Apply screen boundaries
    enforce_screen_bounds()
    
    # Emit position change event
    EventBus.emit_player_position_changed(position)
```

**Impacto**: Difícil de testear y mantener

### 4. **AnimatedBackground.gd - Magic Numbers**

**Problema**: Números mágicos dispersos por el código
```gdscript
cloud.position.x = i * 300.0 + randf_range(-50, 50)
tree.position.y = randf_range(-10, 10)
hill.position.y = randf_range(-15, 15)
```

**Impacto**: Código difícil de entender y mantener

### 5. **PlayerFactory.gd - Switch Statement Smell**

**Problema**: Switch statement largo que viola Open/Closed Principle
```gdscript
match type:
    PlayerType.Type.RUNNER:
        strategy = RunnerStrategy.new(config, player)
    PlayerType.Type.FLYER:
        strategy = FlyerStrategy.new(config, player)
    # ... 6 casos más
```

**Impacto**: Difícil de extender con nuevos tipos

### 6. **PlayerStrategy.gd - Feature Envy**

**Problema**: Acceso excesivo a propiedades del player
```gdscript
player.set_collision_layer_value(1, false)
player.get_viewport().get_visible_rect().size
player.global_position.distance_to(obstacle.global_position)
```

**Impacto**: Alto acoplamiento

### 7. **MainMenuUI.gd - Dead Code**

**Problema**: Código comentado y no utilizado
```gdscript
#button_tween.tween_delay(i * 0.2)  # Línea comentada
# EventBus.game_restarted.connect(_on_game_restarted)  # Comentado
```

**Impacto**: Confusión y mantenimiento innecesario

### 8. **AnimatedBackground.gd - Long Parameter List**

**Problema**: Función con lógica compleja en `_add_random_movement()`
```gdscript
func _add_random_movement(delta: float) -> void:
    var cloud_children = clouds.get_children()
    var current_time = Time.get_time_dict_from_system()
    var time_value = current_time["unix"] if "unix" in current_time else Time.get_unix_time_from_system()
    
    for cloud in cloud_children:
        cloud.position.y += sin(time_value * 0.5 + cloud.position.x * 0.01) * 0.5 * delta
```

**Impacto**: Función difícil de entender

---

## 🔧 **Oportunidades de Refactorización**

### 1. **Extraer Clase de Configuración de Animaciones**

**Problema**: Magic numbers en AnimatedBackground
**Solución**: Crear `AnimationConfig.gd`

```gdscript
class_name AnimationConfig
extends Resource

@export var cloud_spacing: float = 300.0
@export var cloud_random_range: float = 50.0
@export var tree_sway_range: float = 10.0
@export var hill_parallax_range: float = 15.0
```

### 2. **Implementar Patrón Command para Botones**

**Problema**: Código duplicado en MainMenuUI
**Solución**: Crear sistema de comandos

```gdscript
class_name ButtonCommand
extends RefCounted

func execute() -> void:
    pass

class_name PlayCommand
extends ButtonCommand

func execute() -> void:
    EventBus.emit_game_started()
    get_tree().change_scene_to_file("res://src/scenes/main/Main.tscn")
```

### 3. **Dividir EventBus en Módulos Específicos**

**Problema**: God Class con demasiadas responsabilidades
**Solución**: Crear EventBus modular

```gdscript
class_name GameEventBus
extends Node

signal game_started
signal game_paused
signal game_resumed

class_name PlayerEventBus
extends Node

signal player_hit_obstacle
signal player_position_changed(position: Vector2)
```

### 4. **Implementar Builder Pattern para PlayerFactory**

**Problema**: Switch statement largo
**Solución**: Crear PlayerBuilder

```gdscript
class_name PlayerBuilder
extends RefCounted

var _player: CharacterBody2D
var _type: PlayerType.Type
var _position: Vector2

func set_type(type: PlayerType.Type) -> PlayerBuilder:
    _type = type
    return self

func set_position(pos: Vector2) -> PlayerBuilder:
    _position = pos
    return self

func build() -> CharacterBody2D:
    # Lógica de construcción
    return _player
```

### 5. **Crear Sistema de Configuración Centralizado**

**Problema**: Configuraciones dispersas
**Solución**: Crear `GameSettings.gd`

```gdscript
class_name GameSettings
extends Resource

@export_group("Animation")
@export var button_animation_duration: float = 0.3
@export var button_hover_scale: float = 1.1

@export_group("Player")
@export var default_player_type: PlayerType.Type = PlayerType.Type.RUNNER
@export var player_margin_top: float = 50.0
```

### 6. **Implementar Observer Pattern para UI**

**Problema**: Acoplamiento directo con EventBus
**Solución**: Crear UI Observer

```gdscript
class_name UIObserver
extends Node

func _ready() -> void:
    EventBus.game_started.connect(_on_game_started)
    EventBus.game_paused.connect(_on_game_paused)

func _on_game_started() -> void:
    # Lógica específica de UI
    pass
```

### 7. **Crear Sistema de Pooling para Tweens**

**Problema**: Creación constante de nuevos Tweens
**Solución**: Implementar TweenPool

```gdscript
class_name TweenPool
extends Node

var _available_tweens: Array[Tween] = []
var _active_tweens: Array[Tween] = []

func get_tween() -> Tween:
    if _available_tweens.is_empty():
        return create_tween()
    else:
        return _available_tweens.pop_back()

func return_tween(tween: Tween) -> void:
    tween.kill()
    _available_tweens.append(tween)
```

### 8. **Implementar State Machine para Player**

**Problema**: Lógica de estado dispersa
**Solución**: Crear PlayerStateMachine

```gdscript
class_name PlayerStateMachine
extends Node

enum State { IDLE, MOVING, DODGING, TELEPORTING, DEAD }

var current_state: State = State.IDLE
var state_handlers: Dictionary = {}

func change_state(new_state: State) -> void:
    if current_state != new_state:
        _exit_state(current_state)
        current_state = new_state
        _enter_state(new_state)
```

---

## 📈 **Métricas de Calidad**

### **Complejidad Ciclomática**
- **MainMenuUI.gd**: 8 (Alta)
- **EventBus.gd**: 12 (Muy Alta)
- **Player.gd**: 6 (Media)
- **PlayerFactory.gd**: 9 (Alta)

### **Líneas de Código por Archivo**
- **EventBus.gd**: 155 líneas (Demasiado)
- **MainMenuUI.gd**: 179 líneas (Alto)
- **PlayerFactory.gd**: 146 líneas (Alto)

### **Acoplamiento**
- **Alto**: MainMenuUI → EventBus
- **Alto**: Player → EventBus
- **Alto**: PlayerStrategy → Player

---

## 🎯 **Plan de Refactorización Prioritario**

### **Fase 1: Crítico (1-2 días)**
1. ✅ Eliminar código muerto y comentarios
2. ✅ Extraer constantes mágicas
3. ✅ Dividir EventBus en módulos

### **Fase 2: Importante (3-5 días)**
1. 🔄 Implementar Command Pattern para botones
2. 🔄 Crear sistema de configuración centralizado
3. 🔄 Implementar Builder Pattern para PlayerFactory

### **Fase 3: Mejoras (1 semana)**
1. ⏳ Implementar State Machine para Player
2. ⏳ Crear sistema de pooling para Tweens
3. ⏳ Implementar Observer Pattern para UI

---

## 🚀 **Beneficios Esperados**

### **Mantenibilidad**
- ✅ Código más fácil de entender
- ✅ Menos duplicación
- ✅ Mejor organización

### **Extensibilidad**
- ✅ Fácil agregar nuevos tipos de jugador
- ✅ Fácil agregar nuevos eventos
- ✅ Fácil agregar nuevas animaciones

### **Rendimiento**
- ✅ Menos creación de objetos
- ✅ Mejor gestión de memoria
- ✅ Animaciones más eficientes

### **Testabilidad**
- ✅ Código más fácil de testear
- ✅ Mejor separación de responsabilidades
- ✅ Menos acoplamiento

---

## 📝 **Recomendaciones Inmediatas**

1. **Eliminar código muerto** - Limpiar comentarios y código no utilizado
2. **Extraer constantes** - Crear archivo de configuración
3. **Dividir EventBus** - Separar en módulos específicos
4. **Implementar Command Pattern** - Para botones del menú
5. **Crear tests unitarios** - Para funciones críticas

El código actual funciona pero necesita refactorización significativa para ser mantenible y escalable a largo plazo.
