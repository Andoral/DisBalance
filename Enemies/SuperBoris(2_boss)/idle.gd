extends State
@onready var player_collision2d = $"../../PlayerDetection/PlayerDetectionCollision"

var player_entered: bool = false:
	set(value):
		player_entered = value

func _on_player_entered(_body):
	player_entered = true
 
func transition():
	if player_entered:
		get_parent().change_state("Attack")
