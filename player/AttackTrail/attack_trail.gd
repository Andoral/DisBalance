extends Area2D

@export var player : NodePath
@export var duration: float = 0.5 # Увеличено для обеспечения полного проигрывания анимации
@export var fade_out_time: float = 0.2 # Время затухания
var Element: String
var Damage: int

func set_element(_Element: String) -> void:
	Element = _Element
	
func set_damage(power: int) -> void:
	Damage = power

func _ready():
	match Element:
		"Darkness":
			$AnimatedSprite2D.play("AttackTrailDarkness")
		"Light":
			$AnimatedSprite2D.play("AttackTrailLight")
	
	# Создаем tween для плавного затухания
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0.0, fade_out_time).set_delay(duration - fade_out_time)
	
	# Подключаем callback для удаления ноды после завершения затухания
	tween.tween_callback(Callable(self, "queue_free"))

func _on_body_entered(body):
	# Нанесение урона противнику
	if body.has_method("take_damage"):
		body.take_damage(Damage, Element)
