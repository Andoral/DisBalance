extends Node

signal stamina_changed(current_stamina)

var max_stamina = 100
var stamina_regen_rate = 1
var current_stamina: int:
		get = _get_stamina, set = _set_stamina

func _get_stamina() -> int:
	return current_stamina

func _set_stamina(value: int) -> void:
	if value < 0:
		current_stamina = 0
	else: current_stamina = value
	stamina_changed.emit(current_stamina)

func _waste_stamina(value: int) -> int:
	if current_stamina < value:
		return 0
	else: 
		current_stamina -= value
		return 1

func _ready() -> void:
	current_stamina = max_stamina

func _process(_delta: float) -> void:
	pass
