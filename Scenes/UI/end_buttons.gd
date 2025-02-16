@tool
extends XRToolsViewport2DIn3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		hide()
	Events.level_8_load.connect(_on_level_8_load)


func _on_level_8_load() -> void:
	print("Show restart buttons")
	show()


func _on_play_again_pressed() -> void:
	Global.level = 0
	get_tree().reload_current_scene()


func _on_quit_game_pressed() -> void:
	get_tree().quit()
