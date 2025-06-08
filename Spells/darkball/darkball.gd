extends "res://Spells/mainball/mainball.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	launch_animation = "darkball_launch"
	animation_player.play(launch_animation)
	$CPUParticles2D.color = Color('#aa62e4') # Черный цвет для darkball


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
