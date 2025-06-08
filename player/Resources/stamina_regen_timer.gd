extends Timer

@export var stamina_component: Node

func _ready() -> void:
	self.wait_time = 0.1  # Время ожидания в секундах
	self.one_shot = false  # Повторять таймер
	self.autostart = true  # Автоматически запускать таймер при загрузке
	self.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	if stamina_component:
		if stamina_component.current_stamina < stamina_component.max_stamina:
			stamina_component.current_stamina += stamina_component.stamina_regen_rate
