extends CharacterBody2D

@export var mainball_scene: PackedScene
@export var darkball_scene: PackedScene
@export var lightball_scene: PackedScene
@onready var timer = $Timer
@onready var animation_player = $AnimatedSprite2D

var is_darkball_next = true

func _ready():
	timer.wait_time = 0.5
	timer.timeout.connect(_on_Timer_timeout)
	timer.start()
	animation_player.play("idle")
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_Timer_timeout():
	if is_darkball_next:
		spawn_ball(darkball_scene)
	else:
		spawn_ball(lightball_scene)
	is_darkball_next = !is_darkball_next  # Переключение на следующий тип снаряда

func spawn_ball(ball_scene: PackedScene):
	var ball_instance = ball_scene.instantiate()
	ball_instance.position = global_position - Vector2(40, 5)  # Смещение на 40 пикселей влево
	ball_instance.rotation = PI  # Стрельба влево
	get_parent().add_child(ball_instance)

func _on_animation_finished():
		animation_player.play("idle")
