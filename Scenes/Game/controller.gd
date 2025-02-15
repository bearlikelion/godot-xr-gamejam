extends XRController3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_button_pressed(button_name: String) -> void:
	print("Button Pressed %s" % button_name)
	if button_name == "ax_button":
		Events.repeat_instructions.emit()

	if button_name == "by_button":
		if Global.level != 8:
			Events.restart_level.emit()
