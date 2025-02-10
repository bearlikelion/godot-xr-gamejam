extends Node3D

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var icon_marker: Marker3D = $IconMarker


func _ready() -> void:
	animation_player.play("rise")
	audio_stream_player_3d.play()
	Events.new_rune_to_match.connect(_on_new_rune)


func _on_area_3d_area_entered(area: Area3D) -> void:
	if !Global.game_started and area.is_in_group("player_hand"):
		Global.game_started = true
		Events.start_game.emit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "rise":
		Events.podium_rose.emit()


func _on_new_rune(icon_scene: String) -> void:
	var _icon = load(icon_scene).instantiate()

	if icon_marker.get_children().size() > 0:
		for icon_child in icon_marker.get_children():
			icon_child.queue_free()

	icon_marker.add_child(_icon)
