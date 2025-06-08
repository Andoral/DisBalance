extends Node

signal change_element(value)

var Element: String: 
	get = _get_element, set = _set_element

func _get_element() -> String:
	return Element
	
func _set_element(value: String) -> void:
	if value == "Darkness" or value == "Light":
				Element = value
				change_element.emit(value)

func Switch_Element() -> void:
	match Element:
		"Darkness":
			Element = "Light"
		"Light":
			Element = "Darkness"
		"Empty":
			Element = "Empty"
