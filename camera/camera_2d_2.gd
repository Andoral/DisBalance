extends Camera2D

@onready var camera: Camera2D = $"."

# Настройки для камеры
var max_offset := Vector2(70, 50)  # Максимальное смещение камеры по X и Y
var smooth_speed := 2.0  # Скорость плавного смещения камеры

# Текущая позиция отклонения камеры
var target_offset := Vector2.ZERO

func _process(delta):
	# Получаем положение мыши в окне и центр экрана
	var viewport_size = get_viewport_rect().size
	var mouse_position = get_viewport().get_mouse_position()
	var screen_center = viewport_size / 4

	# Рассчитываем вектор отклонения (курсора от центра экрана)
	var offset_direction = (mouse_position - screen_center) / screen_center

	# Ограничиваем смещение в пределах [-1, 1] и умножаем на максимальный оффсет
	target_offset.x = clamp(offset_direction.x, -1, 1) * max_offset.x
	target_offset.y = clamp(offset_direction.y, -1, 1) * max_offset.y

	# Плавно интерполируем смещение камеры
	camera.offset = camera.offset.lerp(target_offset, smooth_speed * delta)

	# Ограничиваем, чтобы главный герой всегда был виден
	_limit_camera_offset()

func _limit_camera_offset():
	# Допустим, что камера имеет смещение (offset) и главный герой всегда в центре
	# В этом случае ограничение влияет на максимальное отклонение камеры.
	# Если понадобится, можно использовать дополнительные проверки для границ камеры.
	pass
