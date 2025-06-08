extends Control


@onready var heart_icon = $Resources/HpAndStamina/HpImage

func set_health(value: int, max_health: int):
	$Resources/HpAndStamina/HpLabel.text = str(value)
	update_heart_icon(value, max_health)
	
func update_heart_icon(current_health: int, max_health: int) -> void:
		var health_percentage = (float(current_health) / float(max_health))
		if health_percentage >= 0.75:
			heart_icon.texture = preload("res://GUI/UI/Resources/HealthMerged1.png")
		elif health_percentage >= 0.50:
			heart_icon.texture = preload("res://GUI/UI/Resources/HealthMerged2.png")
		elif health_percentage >= 0.02:
			heart_icon.texture = preload("res://GUI/UI/Resources/HealthMerged3.png")
		else:
			heart_icon.texture = preload("res://GUI/UI/Resources/HealthMerged4.png")	
	
func set_element(value):
	$Resources/Element/ElementLabel.text = str(value)
	
func set_stamina(value: int) -> void:
	$Resources/HpAndStamina/StaminaBar.value = value

func set_energy(value: int) -> void:
	$Resources/Element/Energy.text = str(value)
	
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	pass
