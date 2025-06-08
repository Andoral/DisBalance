extends Node

@onready var element_component = $"../Elements"

signal health_changed(value) # Изменение ХП
signal health_depleted # Здоровье потрачено
signal max_health_changed(new_max_health) # Изменение маскимального здоровья
signal energy_changed(value) # Изменение энергии 
signal max_energy_changed(new_max_energy) # Изменение максимальной энергии 
signal light_energy_full #Сигнал-оповещение полной энергии света
signal darkness_energy_full #Сигнал-оповещение полной энергии тьмы
signal light_energy_full_to_normal #Сигнал-оповещение о нормализации энергии света
signal darkness_energy_full_to_normal #Сигнал-оповещение о нормализации энергии тьмы

# Стандартные значения
var base_max_health: int = 100
var base_max_energy: int = 100

# Насыщение - Урон в 0.1 секунду от полной энергии
var satiation_damage: int = 1

# Модификаторы
var max_health_modifiers: Array[int] = []
var max_energy_modifiers: Array[int] = []

# Текущие значения
var current_health: int:
	get = _get_health, set = _set_health
var current_energy: int:
	get = _get_energy, set = _set_energy

#Текущее здоровье персонажа
func _get_health() -> int:
		return current_health

func _set_health(value: int) -> void:
		current_health = clamp(value, 0, get_max_health())
		health_changed.emit(current_health)
		if current_health <= 0:
				health_depleted.emit()

func take_damage(damage: int, attackElement: String) -> void:
		match attackElement:
			"Physical":
				_set_health(current_health - damage)	
			"Light":                                
				_set_energy(current_energy + damage)
			"Darkness":
				_set_energy(current_energy - damage)
		

func heal(amount: int) -> void:
		_set_health(current_health + amount)

func get_max_health() -> int:
	var total_modifier = 0
	for modifier in max_health_modifiers:
		total_modifier += modifier
	return max(base_max_health + total_modifier, 1)
	
func add_max_health_modifier(modifier: int) -> void:
	max_health_modifiers.append(modifier)
	var new_max_health = get_max_health()
	current_health = min(current_health, new_max_health)
	max_health_changed.emit(new_max_health)
	health_changed.emit(current_health)
	
func remove_max_health_modifier(modifier: int) -> void:
	max_health_modifiers.erase(modifier)
	var new_max_health = get_max_health()
	current_health = min(current_health, new_max_health)
	max_health_changed.emit(new_max_health)
	health_changed.emit(current_health)
	
func set_base_max_health(new_base_max_health: int) -> void:
	base_max_health = max(new_base_max_health, 1)
	var new_max_health = get_max_health()
	current_health = min(current_health, new_max_health)
	max_health_changed.emit(new_max_health)
	health_changed.emit(current_health)
	
func get_base_max_health() -> int:
	return base_max_health

func _get_energy() -> int:
	return current_energy

func _set_energy(value: int) -> void:
	if value > current_energy:  #Увеличение энергии (Свет)
		if 	current_energy == get_max_energy(): #Энергия Света уже полная
			_set_health(current_health - (value - base_max_energy))
		else: # Энергия Света еще не полная
			if current_energy == -(get_max_energy()): #Энергия Тьмы уже полная
				darkness_energy_full_to_normal.emit()	
			current_energy = clamp(value, -(get_max_energy()), get_max_energy())
			energy_changed.emit(current_energy)
			if current_energy == get_max_energy(): #Теперь энергия Света заполнена
				light_energy_full.emit()
	else: #Уменьшение Энергии (Тьма)
		if current_energy == -(get_max_energy()): #Энергия Тьмы уже полная
			_set_health(current_health - (-(value) - base_max_energy))
		else: #Энергия Тьмы еще не полная
			if 	current_energy == get_max_energy(): #Энергия Света уже полная
				light_energy_full_to_normal.emit()
			current_energy = clamp(value, -(get_max_energy()), get_max_energy())
			energy_changed.emit(current_energy)
			if current_energy == -(get_max_energy()): #Теперь энергия Тьмы заполнена
				darkness_energy_full.emit()

func add_energy(amount: int) -> void:
	_set_energy(current_energy + amount)

func remove_energy(amount: int) -> void:
	_set_energy(current_energy - amount)

func get_max_energy() -> int:
	var total_modifier = 0
	for modifier in max_energy_modifiers:
		total_modifier += modifier
	return max(base_max_energy + total_modifier, 1)

func add_max_energy_modifier(modifier: int) -> void:
	max_energy_modifiers.append(modifier)
	_update_max_energy()

func remove_max_energy_modifier(modifier: int) -> void:
	max_energy_modifiers.erase(modifier)
	_update_max_energy()

func set_base_max_energy(new_base_max_energy: int) -> void:
	base_max_energy = max(new_base_max_energy, 1)
	_update_max_energy()

func get_base_max_energy() -> int:
	return base_max_energy

func _update_max_energy() -> void:
	var new_max_energy = get_max_energy()
	current_energy = min(current_energy, new_max_energy)
	max_energy_changed.emit(new_max_energy)
	energy_changed.emit(current_energy)

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	current_health = get_max_health()
	current_energy = 0	
