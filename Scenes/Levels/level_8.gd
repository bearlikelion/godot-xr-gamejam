extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "appear":
		await get_tree().create_timer(3.0).timeout
		Events.show_credits.emit()
