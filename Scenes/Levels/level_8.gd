extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.level = 8

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "appear":
		Events.show_credits.emit()
