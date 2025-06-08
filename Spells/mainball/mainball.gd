extends Area2D

@export var speed = 600 # Cкорость
@onready var animation_player = $AnimatedSprite2D
@export var damage = 10 # Урон
@export var Element: String
@export var launch_animation = "ball_launch"
@export var broke_animation = "ball_broke"

func _ready():
	animation_player.play(launch_animation)
	# Подключаем сигнал завершения анимации
	animation_player.animation_finished.connect(_on_animation_finished)

# Функция для полета проджектайла
func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body):
	speed = 0 # Останавливаем движение
	animation_player.play(broke_animation)
	_on_animation_finished()
	
	# Нанесение урона противнику
	if body.has_method("take_damage"):
		body.take_damage(damage, Element)

func _on_area_entered(area: Area2D) -> void:
	speed = 0 # Останавливаем движение
	animation_player.play(broke_animation)
	_on_animation_finished()

func _on_animation_finished():
	await animation_player.animation_finished
	queue_free()
