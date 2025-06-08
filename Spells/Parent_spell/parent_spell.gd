extends Area2D

# Оставить для наследования других спеллов (лазеров)
@export var speed = 600 # Cкорость
@onready var animation_player = $AnimatedSprite2D
@export var damage = 10 # Урон
@export var Element: String
