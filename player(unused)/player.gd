extends CharacterBody2D
@onready var health_component = $"../../Resources/Health"
@onready var element_component = $"../../Resources/Elements"
#Здоровье и ресурсы

#Здоровье
signal change_health(value)

var health: int: get = _get_health, set = _set_health

func _get_health() -> int:
	return health
	
func _set_health(value: int) -> void:
	health = value
	change_health.emit(value)
	if health <= 0:
		queue_free()
	
#Функция получения урона игроком
func take_damage(damage: int) -> void:
	health -= damage

#Функция изменения хп на UI
func _on_change_health(value: Variant) -> void:
	$"../../Ui".set_health(value, health_component.get_max_health())

#Функция запуска сцены и определения переменных	КАСТЫЛЬ
func _ready() -> void:
	health = 100 # Replace with function body.

var max_speed = 290
@onready var animated_sprite = $AnimatedSprite2D
var fireball_scene = preload("res://Spells/fireball/fireball.tscn") # Сцена файрбола
var iceball_scene = preload("res://Spells/iceball/iceball.tscn") # Сцена айсрбола
var poisonball_scene = preload("res://Spells/poisonball/poisonball.tscn") # Сцена айсрбола

# Для телепорта
var can_teleport = true
var teleport_cooldown = 1.0
var teleport_timer = 0.0

# Физический процесс управления персонажем
func _physics_process(_delta):
			var direction = movement_vector().normalized()
			velocity = max_speed * direction
			move_and_slide()
			update_animation(direction)

			# Обработка телепортации
			if Input.is_action_just_pressed("space") and can_teleport:
							teleport(direction)

			if teleport_timer > 0:
							teleport_timer -= _delta
							if teleport_timer <= 0:
											can_teleport = true

# Получение вектора направления движения персонажа
func movement_vector():
			var movement_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
			var movement_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
			return Vector2(movement_x, movement_y)

# Обновление анимации в зависимости от направления персонажа
func update_animation(direction: Vector2):
			if direction.length() > 0:
							animated_sprite.play("run")
			else:
							animated_sprite.play("idle")
			
			if direction.x != 0:
							animated_sprite.flip_h = direction.x < 0

# Логика выстрела файерболом
func _process(_delta):
			if Input.is_action_just_pressed("rcm"):
							spawn_fireball()
			if Input.is_action_just_pressed("temp"):
							spawn_iceball()
			if Input.is_action_just_pressed("defensive_spell"):
							spawn_poisonball()              

# Спавн файербола с учетом направления на курсор
func spawn_fireball():
			var fireball = fireball_scene.instantiate()

			# Получаем глобальную позицию мыши
			var mouse_pos = get_global_mouse_position()

			# Вычисляем направление от игрока к мышке
			var direction_to_mouse = (mouse_pos - (position + Vector2(0, -20))).normalized()

			# Смещение фаербола относительно игрока
			# Смещаем на 15 пикселей в сторону от игрока по направлению к курсору
			var offset = direction_to_mouse * 25
# Дополнительное смещение по оси Y (отрицательное значение для перемещения вверх)
			var y_offset = Vector2(0, -20)  # Поднимем на 20 пикселей

			# Устанавливаем позицию фаербола с учетом смещений
			fireball.position = position + offset + y_offset

			# Устанавливаем направление полета фаербола (вращение в сторону мыши)
			fireball.rotation = direction_to_mouse.angle()

			# Устанавливаем угол анимации фаербола
			fireball.get_node("AnimatedSprite2D").rotation_degrees = -90

			# Добавляем фаербол на сцену
			get_parent().add_child(fireball)

# Спавн айсбола с учетом направления на курсор
func spawn_iceball():
			var iceball = iceball_scene.instantiate()

			# Получаем глобальную позицию мыши
			var mouse_pos = get_global_mouse_position()

			# Вычисляем направление от игрока к мышке
			var direction_to_mouse = (mouse_pos - (position + Vector2(0, -20))).normalized()

			# Смещение фаербола относительно игрока
			# Смещаем на 15 пикселей в сторону от игрока по направлению к курсору
			var offset = direction_to_mouse * 25
# Дополнительное смещение по оси Y (отрицательное значение для перемещения вверх)
			var y_offset = Vector2(0, -20)  # Поднимем на 20 пикселей

			# Устанавливаем позицию фаербола с учетом смещений
			iceball.position = position + offset + y_offset

			# Устанавливаем направление полета фаербола (вращение в сторону мыши)
			iceball.rotation = direction_to_mouse.angle()

			# Устанавливаем угол анимации фаербола
			iceball.get_node("AnimatedSprite2D").rotation_degrees = -90

			# Добавляем фаербол на сцену
			get_parent().add_child(iceball)


# Спавн поизонбола с учетом направления на курсор
func spawn_poisonball():
			var poisonball = poisonball_scene.instantiate()

			# Получаем глобальную позицию мыши
			var mouse_pos = get_global_mouse_position()

			# Вычисляем направление от игрока к мышке
			var direction_to_mouse = (mouse_pos - (position + Vector2(0, -20))).normalized()

			# Смещение фаербола относительно игрока
			# Смещаем на 15 пикселей в сторону от игрока по направлению к курсору
			var offset = direction_to_mouse * 25
# Дополнительное смещение по оси Y (отрицательное значение для перемещения вверх)
			var y_offset = Vector2(0, -20)  # Поднимем на 20 пикселей

			# Устанавливаем позицию фаербола с учетом смещений
			poisonball.position = position + offset + y_offset

			# Устанавливаем направление полета фаербола (вращение в сторону мыши)
			poisonball.rotation = direction_to_mouse.angle()

			# Устанавливаем угол анимации фаербола
			poisonball.get_node("AnimatedSprite2D").rotation_degrees = -90

			# Добавляем фаербол на сцену
			get_parent().add_child(poisonball)

# Функция телепортации
func teleport(direction: Vector2):
			can_teleport = false
			teleport_timer = teleport_cooldown
			position += direction * 100 # Телепортируемся на 100 пикселей в направлении движения
