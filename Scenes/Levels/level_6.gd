class_name Level6
extends Node3D

const PICKABLE_POTIONS = preload("res://Resources/Level6/pickable_potions.tres")
const COMBINING_POTION = preload("res://Scenes/Game/Potions/combining_potion.tscn")

@onready var potions: Node = $Level6/Potions
@onready var fail_sound: AudioStreamPlayer3D = $Level6/FailSound
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $Level6/AudioStreamPlayer3D
@onready var animation_player: AnimationPlayer = $Level6/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.level = 7
	animation_player.play("appear")
	Events.reset_potions.connect(_on_reset_potions)
	Events.level_6_completed.connect(_on_level_6_compelted)
	Events.restart_level.connect(_on_restart_level)


func place_potions() -> void:
	var potions_to_pick: Array = PICKABLE_POTIONS.potions.duplicate()
	potions_to_pick.shuffle()

	for postion_pos: Marker3D in potions.get_children():
		var _potion: Potion = potions_to_pick.pop_front().instantiate()
		_potion.add_to_group("potion")
		postion_pos.add_child(_potion)


func _on_reset_potions() -> void:
	fail_sound.play()

	for potion: Potion in get_tree().get_nodes_in_group("potion"):
		potion.queue_free()

	await get_tree().create_timer(2.0).timeout
	place_potions()


func _on_level_6_compelted() -> void:
	audio_stream_player_3d.play()
	animation_player.play("fade")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "appear":
		Events.place_on_pedistal.emit(COMBINING_POTION.resource_path)
		place_potions()

	if anim_name == "fade":
		Events.level_7_load.emit()


func _on_restart_level() -> void:
	animation_player.play("fade")
