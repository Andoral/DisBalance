extends CharacterBody2D

@export var max_health: float = 100
var current_health: float = max_health

# Ссылка на узел TextureProgressBar
@onready var health_bar: TextureProgressBar = $HealthBar/TextureProgressBar
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	update_health_bar()
	animated_sprite.play("idle_1")

func take_damage(amount: int, Element: String):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	update_health_bar()
	if current_health <= 0:
		die()

func update_health_bar():
	health_bar.max_value = max_health
	health_bar.value = current_health

func die():
	# Логика смерти противника
	queue_free()

@onready var hp_bar_control = $HealthBar

func _process(delta):
	# Обновляем позицию HP Bar
	update_hp_bar_position()

func _process_unhandled_input(event):
	# Обновляем позицию HP Bar в редакторе
	if Engine.is_editor_hint():
		update_hp_bar_position()

func update_hp_bar_position():
	# Получаем позицию противника в глобальных координатах
	var enemy_global_position = global_position
	# Рассчитываем позицию HP Bar над головой
	var hp_bar_position = enemy_global_position + Vector2(0, 0) # Отрегулируйте смещение по Y
	# Устанавливаем позицию HP Bar Control
	hp_bar_control.global_position = hp_bar_position
