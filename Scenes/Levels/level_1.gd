class_name Level1
extends StaticBody3D

const RUNE_ICONS = preload("res://Resources/Level1/rune_icons.tres")
const PICKABLE_RUNES = preload("res://Resources/Level1/pickable_runes.tres")

var match_rune: PickableRune

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	collision_shape_3d.disabled = true
	Events.start_game.connect(_on_start_game)
	Events.level_1_completed.connect(_on_level_1_completed)


func _on_start_game() -> void:
	generate_runes() # Generate runes
	show()
	collision_shape_3d.disabled = false
	animation_player.play("appear")


func generate_runes() -> void:
	# Place a random rune on the podium
	var runic_icons: Array = RUNE_ICONS.duplicate().rune_icons
	runic_icons.shuffle()
	var rune_to_match: Resource = runic_icons.pop_front()
	Events.new_rune_to_match.emit(rune_to_match.resource_path)

	var pickable_runes: Array = PICKABLE_RUNES.duplicate().pickable_runes
	var rune_positions: Array[Node] = get_node("Runes").get_children()
	rune_positions.shuffle()

	# Place one match rune at a random position
	for pickable_rune: Resource in pickable_runes:
		if pickable_rune.resource_path.get_file().replace("rune_", "") == \
		rune_to_match.resource_path.get_file().replace("icon_", ""):
			print("Match rune: %s" % pickable_rune.resource_path.get_file())
			var first_position: Marker3D = rune_positions.front()
			var first_rune: PackedScene = load(pickable_rune.resource_path)
			match_rune = first_rune.instantiate()
			first_position.add_child(match_rune)
			pickable_runes.erase(pickable_rune) # Only one correct rune

	# Fill the room with random runes
	for rune_position: Marker3D in rune_positions:
		pickable_runes.shuffle()
		var _rune: PackedScene = load(pickable_runes.front().resource_path)
		if rune_position.get_child_count() == 0:
			print("Place Rune")
			rune_position.add_child(_rune.instantiate())


func _on_level_1_completed() -> void:
	audio_stream_player_3d.play()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		match_rune.queue_free()
		Events.level_2_load.emit()
		collision_shape_3d.disabled = true
		hide()


func _on_audio_stream_player_3d_finished() -> void:
	animation_player.play("fade")
