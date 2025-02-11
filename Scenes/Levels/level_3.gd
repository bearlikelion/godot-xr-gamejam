class_name Level3
extends StaticBody3D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()
	animation_player.play("appear")

	# Events.start_game.connect(_on_start_game)


func _on_start_game() -> void:
	show()
	animation_player.play("appear")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		Events.level_3_load.emit()
		hide()


func _on_audio_stream_player_3d_finished() -> void:
	animation_player.play("fade")


func _on_level_3_completed() -> void:
	audio_stream_player_3d.play()
