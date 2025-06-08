extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	animated_sprite.animation_finished
