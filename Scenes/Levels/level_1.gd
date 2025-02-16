class_name Level1
extends StaticBody3D

@export var matches_required: int = 3

var match_rune: BaseRune
var current_matches: int = 0
var _remaining_runes: Array[BaseRune]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var rune_config: RuneConfig = $Runes


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Global.level = 1

	if not rune_config:
		push_error("RuneConfig not assigned to Level1")
		return
	Events.start_game.connect(_on_start_game)
	Events.level_1_completed.connect(_on_level_1_completed)
	Events.restart_level.connect(_on_restart_level)
	Events.rune_matched.connect(_on_rune_matched)
	Events.runes_faded_out.connect(_on_runes_faded_out)

	# Generate initial runes and place the match rune immediately
	if Global.level == 1:
		generate_new_rune_set()
		Events.place_on_pedistal.emit(match_rune)
		_on_start_game()

func _on_start_game() -> void:
	show()
	animation_player.play("appear")

# Generates a new set of runes and selects one as the match target
func generate_new_rune_set() -> void:
	if rune_config.runes.is_empty():
		push_error("No runes available in RuneConfig")
		return

	# Generate all runes for this round
	_remaining_runes = rune_config.create_random_runes(get_node("Runes").get_child_count())
	if _remaining_runes.is_empty():
		push_error("Failed to create runes")
		return

	# Set the first rune as our match target
	match_rune = _remaining_runes[0]

# Places the remaining runes in the level
func place_remaining_runes() -> void:
	# Get all rune positions
	var rune_positions: Array[Node] = get_node("Runes").get_children()
	if rune_positions.is_empty():
		push_error("No rune positions found in Level1")
		return

	# Fade out existing runes except the match rune
	var has_existing_runes := false
	for pos in rune_positions:
		for child in pos.get_children():
			if child is BaseRune and child != match_rune:
				has_existing_runes = true
				child.fade_out()

	# If there were no runes to fade out, place new ones immediately
	if not has_existing_runes:
		_place_new_runes()

func _place_new_runes() -> void:
	var rune_positions: Array[Node] = get_node("Runes").get_children()

	if not Global.testing:
		rune_positions.shuffle()

	# Make sure all remaining runes are removed from their current parents first
	for rune in _remaining_runes:
		if rune.get_parent():
			rune.get_parent().remove_child(rune)

	# Place all remaining runes in positions and fade them in
	for i in range(_remaining_runes.size()):
		_remaining_runes[i]._is_bobbing = true
		rune_positions[i].add_child(_remaining_runes[i])
		_remaining_runes[i].fade_in()

func _on_runes_faded_out() -> void:
	# Place new runes after old ones have faded out
	_place_new_runes()

func _on_level_1_completed() -> void:
	audio_stream_player_3d.play()

func _on_rune_matched() -> void:
	current_matches += 1
	if current_matches >= matches_required:
		# Fade out all runes before completing level
		var rune_positions: Array[Node] = get_node("Runes").get_children()
		for pos in rune_positions:
			for child in pos.get_children():
				if child is BaseRune:
					child.fade_out()

		# Also fade out the match rune on the pedestal
		if match_rune:
			match_rune.fade_out()

		Events.level_1_completed.emit()
	else:
		# Generate new set of runes and place the match rune
		generate_new_rune_set()
		Events.place_on_pedistal.emit(match_rune)

		# Start the fade out/fade in sequence
		place_remaining_runes()

		# Emit a signal to update the progress display
		Events.update_match_progress.emit(current_matches, matches_required)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "appear":
		Events.level_1_instructions.emit()
		place_remaining_runes()  # Place remaining runes after level appears

	if anim_name == "fade":
		Events.level_2_load.emit()
		collision_shape_3d.disabled = true
		hide()

func _on_audio_stream_player_3d_finished() -> void:
	animation_player.play("fade")

func _on_restart_level() -> void:
	current_matches = 0
	animation_player.play("fade")
