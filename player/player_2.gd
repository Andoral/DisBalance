extends CharacterBody2D

@export var AttackTrailScene: PackedScene = preload("res://player/AttackTrail/attack_trail.tscn")
@export var DeathEffectScene: PackedScene = preload("res://player/death_effect.tscn")

@export_category("Statistics")
@export var power : int = 10 #Изначальная cила персонажа, все способноости и атаки зависят от нее
@export var energy_power : int  = 0 # Сила персонажа, зависящая от энергии элемента
@export var strenght : int # Полная сила персонажа = strenght + (strenght * energy_power / 200)
@export var max_speed = 400 #Скорость передвижения персонажа
@export var is_attacking = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var effect_sprite = $AnimatedSprite2D/EffectSprite2D
@onready var health_component = $Resources/Health
@onready var element_component = $Resources/Elements
@onready var stamina_component = $Resources/Stamina
@onready var dash_particles_light = $dash_particles_light
@onready var dash_particles_dark = $dash_particles_dark

func take_damage(damage: int, attackElement: String) -> void:
		health_component.take_damage(damage, attackElement)

func _on_health_changed(value: Variant) -> void:
		$"Ui".set_health(value, health_component.get_max_health())

func _on_health_depleted() -> void:
		die()

func _on_change_element(value: String) -> void:
		$"Ui".set_element(value)

func _on_change_stamina(value: Variant) -> void:
		$"Ui".set_stamina(value)
		
func _on_change_energy(value: Variant) -> void:
		energy_power = value 
		$"Ui".set_energy(value)
		
func _ready() -> void:
		health_component.health_changed.connect(_on_health_changed)
		health_component.health_depleted.connect(_on_health_depleted)
		health_component.energy_changed.connect(_on_change_energy)
		element_component.change_element.connect(_on_change_element)
		stamina_component.stamina_changed.connect(_on_change_stamina)
		element_component.Element = "Light"

func _process(_delta):
		# Смена элемента по нажатию
		if Input.is_action_just_pressed("ChangeElement"):
				element_component.Switch_Element()
				effect_sprite.visible = true
				match element_component.Element:
						"Light":                                
								effect_sprite.play("switchLight")                               
						"Darkness":
								effect_sprite.play("switchDarkness")
				await effect_sprite.animation_finished
				effect_sprite.visible = false

func _physics_process(_delta):
		# Если не атакуем (и не в рывке), проверяем входные действия
		if not is_attacking:
				if Input.is_action_just_pressed("lcm"):
						attack()
				elif Input.is_action_just_pressed("charge"):
						charge()

		# Движение:
		if not is_attacking:
				# Обычное движение, если не атакуем и не в рывке
				var direction = movement_vector().normalized()
				velocity = max_speed * direction
				update_animation(direction)
		# Если is_attacking == true, значит либо атака, либо рывок — движение не обновляем,
		# персонаж или стоит на месте (атака) или "скользит" по инерции (рывок).
		
		move_and_slide()

func movement_vector():
		var movement_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var movement_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		return Vector2(movement_x, movement_y)

func update_animation(direction: Vector2):
		if direction.length() > 0:
				match element_component.Element:
						"Light":
								animated_sprite.play("run_multi")
						"Darkness":
								animated_sprite.play("run_multi")
		else:
				match element_component.Element:
						"Light":
								animated_sprite.play("idle_multi")
						"Darkness":
								animated_sprite.play("idle_multi")

		if direction.x != 0:
				animated_sprite.flip_h = direction.x < 0

func attack():
		if stamina_component._waste_stamina(10) == 1:
				is_attacking = true
				# При атаке персонаж останавливается
				velocity = Vector2.ZERO
				
				match element_component.Element:
						"Light":
								animated_sprite.play("attack_multi")
						"Darkness":
								animated_sprite.play("attack_multi")

				# Подключаемся к сигналу конца анимации,
				# чтобы потом вернуть управление
				animated_sprite.animation_finished.connect(_on_attack_finished)

				var mouse_position = get_global_mouse_position()
				var direction = (mouse_position - global_position).normalized()

				animated_sprite.flip_h = mouse_position.x < global_position.x

				var attack_trail = AttackTrailScene.instantiate()
				attack_trail.set_element(element_component.Element)
				attack_trail.set_damage(power)
				
				# Смещение для правильного позиционирования
				var trail_offset = direction * 40 + Vector2(0, -32)
				attack_trail.global_position = global_position + trail_offset
				attack_trail.rotation = direction.angle()
				get_parent().add_child(attack_trail)

func charge():
	if stamina_component._waste_stamina(5) == 1:
		is_attacking = true
		var direction = movement_vector().normalized()
		velocity = max_speed * direction * 4 
		# Отключаем оба эффекта перед включением нужного
		dash_particles_light.emitting = false
		dash_particles_dark.emitting = false

		match element_component.Element:
			"Light":
				dash_particles_light.emitting = true
				animated_sprite.play("charge_multi")
			"Darkness":
				dash_particles_dark.emitting = true
				animated_sprite.play("charge_multi")
		animated_sprite.animation_finished.connect(_on_charge_finished)

func _on_attack_finished():
		is_attacking = false
		animated_sprite.animation_finished.disconnect(_on_attack_finished)
		update_animation(movement_vector().normalized())

func _on_charge_finished():
	dash_particles_light.emitting = false
	dash_particles_dark.emitting = false
	velocity = Vector2.ZERO
	is_attacking = false
	animated_sprite.animation_finished.disconnect(_on_charge_finished)
	update_animation(movement_vector().normalized())

func die():
		# Создаём экземпляр сцены смерти
		var death_effect = DeathEffectScene.instantiate()
		death_effect.global_position = global_position
		
		# Выбираем анимацию смерти по элементу
		var death_animation = ""
		match element_component.Element:
				"Light":
						death_animation = "die_multi"
				"Darkness":
						death_animation = "die_multi"

		death_effect.get_node("AnimatedSprite2D").play(death_animation)
		get_parent().add_child(death_effect)
		
		call_deferred("queue_free")
		set_physics_process(false)
		match element_component.Element:
				"Light":
						animated_sprite.play("die_multi")
				"Darkness":
						animated_sprite.play("die_multi")
		await animated_sprite.animation_finished
		queue_free()
