extends AnimatedSprite2D

var shader_material = ShaderMaterial.new()
var shader = preload("res://player/death_effect.gdshader")
var health_energy_value = 0.0
var original_material
var element_state = 0  # 0 = Darkness, 1 = Light

func _ready():
	original_material = self.material.duplicate()
	shader_material.shader = shader
	self.material = shader_material

func _process(delta):
	if animation in ["idle_multi", "charge_multi", "run_multi", "attack_multi", "die_multi"]:
		if self.material != shader_material:
			self.material = shader_material
		shader_material.set_shader_parameter("_on_health_energy_changed", health_energy_value)
		shader_material.set_shader_parameter("_on_element_changed", element_state)
	else:
		if self.material != original_material:
			self.material = original_material

func _on_health_energy_changed(value: Variant) -> void:
	health_energy_value = clamp(value, -100, 100)
	shader_material.set_shader_parameter("_on_health_energy_changed", health_energy_value)

func _on_elements_change_element(value: Variant) -> void:
	if value == "Darkness":
		element_state = 0
	elif value == "Light":
		element_state = 1
	shader_material.set_shader_parameter("_on_element_changed", element_state)
