extends Node3D

var staff_forged: bool = false

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var icon_marker: Marker3D = $IconMarker
@onready var podium_snap_zone: PodiumSnapZone = $PodiumSnapZone

var _pending_rune: BaseRune = null

func _ready() -> void:
	animation_player.play("rise")
	audio_stream_player_3d.play()
	Events.place_on_pedistal.connect(_on_place_on_pedistal)
	Events.level_1_completed.connect(_on_level_completed)
	Events.level_2_completed.connect(_on_level_completed)
	Events.level_4_completed.connect(_on_level_4_completed)
	Events.level_6_completed.connect(_on_level_completed)
	Events.staff_forged.connect(_on_staff_forged)
	Events.runes_faded_out.connect(_on_runes_faded_out)


func _on_area_3d_area_entered(area: Area3D) -> void:
	if not Global.game_started and area.is_in_group("player_hand"):
		Global.game_started = true

		if Global.level <= 1:
			Events.level_1_load.emit()

		Events.start_game.emit()
		Events.rumble.emit("LEFT", "PODIUM")
		Events.rumble.emit("RIGHT", "PODIUM")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "rise":
		Events.podium_rose.emit()

func _on_place_on_pedistal(scene_string_or_base_rune: Variant) -> void:

	if type_string(typeof(scene_string_or_base_rune)) == "String":
		_on_place_on_pedistal_string(scene_string_or_base_rune)
	else: # Assume base_rune
		_on_place_on_pedistal_rune(scene_string_or_base_rune)


func _on_place_on_pedistal_string(scene_string: String) -> void:
	var _item: Node3D = load(scene_string).instantiate()

	if icon_marker.get_child_count() > 0:
		for icon_child in icon_marker.get_children():
			icon_child.queue_free()

	icon_marker.add_child(_item)

func _on_place_on_pedistal_rune(base_rune: BaseRune) -> void:
	# Store the rune to be placed
	_pending_rune = base_rune.duplicate()
	_pending_rune.enabled = false  # Make it so it can't be picked up
	_pending_rune.freeze = true

	# If there's an existing rune, fade it out first
	if icon_marker.get_child_count() > 0:
		for icon_child in icon_marker.get_children():
			if icon_child is BaseRune:
				icon_child.fade_out()
	else:
		# If no existing rune, place the new one immediately
		_place_pending_rune()

func _place_pending_rune() -> void:
	if not _pending_rune:
		return

	var temp_mesh: GeometryInstance3D = _pending_rune.get_child(2)
	temp_mesh.set_surface_override_material(0, load("res://Shaders/3d_transparent_ripples_wave.tres"))

	icon_marker.add_child(_pending_rune)
	_pending_rune.fade_in()
	_pending_rune = null

func _on_runes_faded_out() -> void:
	# Place the pending rune after the old one has faded out
	_place_pending_rune()

func _on_level_completed() -> void:
	# Remove icon marker child on level compelte
	if icon_marker.get_children().size() > 0:
		for icon_child in icon_marker.get_children():
			icon_child.queue_free()


func _on_staff_forged() -> void:
	staff_forged = true


func _on_level_4_completed() -> void:
	podium_snap_zone.hide()


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
			Global.forged_staff = what.duplicate()
			Events.level_4_completed.emit()
