extends CharacterBody2D

@export var max_speed = 300
@export var health: int = 100
@export var damage: int = 20

signal damaged(amount)
signal died

# Функция, вызываемая каждый кадр
func _physics_process(delta):
	move_enemy(delta)

# Функция для движения врага
func move_enemy(delta):
	pass

# Функция для получения урона
func take_damage(amount):
	health -= amount
	emit_signal("damaged", amount)
	if health <= 0:
		die()

# Функция для смерти врага
func die():
	emit_signal("died")
	queue_free()
