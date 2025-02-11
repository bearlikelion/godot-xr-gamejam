extends Node3D

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var icon_marker: Marker3D = $IconMarker


func _ready() -> void:
	animation_player.play("rise")
	audio_stream_player_3d.play()
	Events.new_rune_to_match.connect(_on_new_rune)
	Events.level_1_completed.connect(_on_level_1_completed)


func _on_area_3d_area_entered(area: Area3D) -> void:
	if !Global.game_started and area.is_in_group("player_hand"):
		Global.game_started = true
		Events.start_game.emit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "rise":
		Events.podium_rose.emit()


func _on_new_rune(icon_scene: String) -> void:
	var _icon: Node3D = load(icon_scene).instantiate()

	if icon_marker.get_children().size() > 0:
		for icon_child in icon_marker.get_children():
			icon_child.queue_free()

	icon_marker.add_child(_icon)


func _on_level_1_completed() -> void:
	# Remove rune when level 1 completed
	if icon_marker.get_children().size() > 0:
		for icon_child in icon_marker.get_children():
			icon_child.queue_free()


func _on_podium_snap_zone_2_has_picked_up(what: Variant) -> void:
	print("Snapped to podium: %s" % what)
	if Global.level == 1:
		if what is PickableRune:
			Events.podium_snapped.emit(what.rune_name)

	if Global.level == 2:
		if what is MagicBook:
			Events.podium_snapped.emit(what.book_name)
