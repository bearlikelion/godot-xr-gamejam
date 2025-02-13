class_name Level6
extends Node3D

const PICKABLE_POTIONS = preload("res://Resources/Level6/pickable_potions.tres")
const COMBINING_POTION = preload("res://Scenes/Game/Potions/combining_potion.tscn")

@onready var potions: Node = $Level6/Potions
@onready var fail_sound: AudioStreamPlayer3D = $Level6/FailSound
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $Level6/AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.place_on_pedistal.emit(COMBINING_POTION.resource_path)
	Events.reset_potions.connect(_on_reset_potions)
	Events.level_6_completed.connect(_on_level_6_compelted)
	place_potions()


func place_potions() -> void:
	var potions_to_pick: Array = PICKABLE_POTIONS.potions.duplicate()
	potions_to_pick.shuffle()

	for postion_pos: Marker3D in potions.get_children():
		postion_pos.add_child(potions_to_pick.pop_front().instantiate())


func _on_reset_potions() -> void:
	fail_sound.play()

	for postion_pos: Marker3D in potions.get_children():
		postion_pos.get_child(0).queue_free()

	await get_tree().create_timer(2.0).timeout
	place_potions()


func _on_level_6_compelted() -> void:
	audio_stream_player_3d.play()
