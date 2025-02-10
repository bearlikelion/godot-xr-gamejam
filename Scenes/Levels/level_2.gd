extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Events.level_2_load.connect(_on_level_2_load)


func _on_level_1_completed() -> void:
	audio_stream_player_3d.play()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		Events.load_level_2.emit()
		hide()

func _on_audio_stream_player_3d_finished() -> void:
	animation_player.play("fade")


func _on_level_2_load() -> void:
	show()
	animation_player.play("appear")
