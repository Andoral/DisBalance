extends Timer

@onready var health_component = get_parent()

var timer: Timer

func _ready() -> void:
	timer = Timer.new()
	timer.set_wait_time(0.1)
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	health_component.connect("light_energy_full", Callable(self, "_on_light_energy_full"))
	health_component.connect("darkness_energy_full", Callable(self, "_on_darkness_energy_full"))
	health_component.connect("light_energy_full_to_normal", Callable(self, "_on_light_energy_full_to_normal"))
	health_component.connect("darkness_energy_full_to_normal", Callable(self, "_on_darkness_energy_full_to_normal"))

func _on_timer_timeout() -> void:
		health_component.take_damage(health_component.satiation_damage, "Physical")

func _on_light_energy_full() -> void:
	timer.start()

func _on_darkness_energy_full() -> void:
	timer.start()

func _on_light_energy_full_to_normal() -> void:
	timer.stop()

func _on_darkness_energy_full_to_normal() -> void:
	timer.stop()
