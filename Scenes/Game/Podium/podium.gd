extends Node3D

var staff_forged: bool = false

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var icon_marker: Marker3D = $IconMarker
@onready var podium_snap_zone: Area3D = $PodiumSnapZone


func _ready() -> void:
	animation_player.play("rise")
	audio_stream_player_3d.play()
	Events.place_on_pedistal.connect(_on_place_on_pedistal)
	Events.level_1_completed.connect(_on_level_completed)
	Events.level_2_completed.connect(_on_level_completed)
	Events.level_6_completed.connect(_on_level_completed)
	Events.staff_forged.connect(_on_staff_forged)


func _on_area_3d_area_entered(area: Area3D) -> void:
	if !Global.game_started and area.is_in_group("player_hand"):
		Global.game_started = true
		Events.start_game.emit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "rise":
		Events.podium_rose.emit()


func _on_place_on_pedistal(base_rune: BaseRune) -> void:
	base_rune = base_rune.duplicate()
	base_rune.enabled = false  # Make it so it can't be picked up

	if icon_marker.get_child_count() > 0:
		for icon_child in icon_marker.get_children():
			icon_child.queue_free()

	icon_marker.add_child(base_rune)


func _on_level_completed() -> void:
	# Remove icon marker child on level compelte
	if icon_marker.get_children().size() > 0:
		for icon_child in icon_marker.get_children():
			icon_child.queue_free()


func _on_staff_forged() -> void:
	staff_forged = true


func _on_podium_snap_zone_has_picked_up(what: Variant) -> void:
	print("Snapped to podium: %s" % what)
	if Global.level == 1:
		if what is BaseRune:
			Events.podium_snapped.emit(what.rune_name)

	if Global.level == 2:
		if what is MagicBook:
			Events.podium_snapped.emit(what.book_name)

	if Global.level == 3:
		if what is PickableCrystal:
			if what.magic_crystal == true:
				what.reparent(get_tree().get_first_node_in_group("base"), true)
				Events.podium_snapped.emit("magic_crystal")
				podium_snap_zone.enabled = false
				print("podium snap zone is not oke doke")
			else:
				what.breakable = true
				Events.podium_snapped.emit("weak_crystal")

	if Global.level == 4:
		if what is Staff and staff_forged:
			what.reparent(get_tree().get_first_node_in_group("base"), true)
			Events.level_4_completed.emit()
