@tool
extends XRToolsViewport2DIn3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		hide()

	Events.level_8_load.connect(_on_level_8_load)


func _on_level_8_load() -> void:
	show()
