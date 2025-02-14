extends Node3D


func _on_interactable_area_button_button_pressed(button: Variant) -> void:
	print("Button pressed: %s" % button.get_parent().name)
	Events.button_pushed.emit(button.get_parent().name)
