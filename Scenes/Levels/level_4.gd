class_name Level4
extends StaticBody3D

const PICKABLE_CRYSTAL = preload("res://Scenes/Game/Crystals/pickable_crystal.tscn")

var magic_crystal: RigidBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var fail_sound: AudioStreamPlayer3D = $FailSound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()
	Global.level = 3
	animation_player.play("appear")

	Events.level_3_completed.connect(_on_level_4_completed)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		magic_crystal.queue_free()
		Events.level_5_load.emit()
		hide()


func _on_audio_stream_player_3d_finished() -> void:
	animation_player.play("fade")


func _on_level_4_completed() -> void:
	audio_stream_player_3d.play()
