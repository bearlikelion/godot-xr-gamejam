extends Node3D

var grow_potion_scene: String = "res://Scenes/Game/Potions/Lvl8Potions/grow_potion.tscn"

func _ready() -> void:
	Global.level = 8
	spawn_grow_potion()
	Events.grow_potion_used.connect(spawn_grow_potion)


func spawn_grow_potion() -> void:
	Events.place_on_pedistal.emit(grow_potion_scene)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "appear":
		Events.show_credits.emit()
