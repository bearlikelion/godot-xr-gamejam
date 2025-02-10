extends Node3D

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("rise")
	audio_stream_player_3d.play()


func _on_area_3d_area_entered(area: Area3D) -> void:
	if !Global.game_started and area.is_in_group("player_hand"):
		Global.game_started = true
		Events.start_game.emit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "rise":
		Events.podium_rose.emit()
