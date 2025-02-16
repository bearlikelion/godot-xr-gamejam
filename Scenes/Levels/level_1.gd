class_name Level1
extends StaticBody3D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var rune_config: RuneConfig = $Runes

var match_rune: BaseRune
var matches_required: int = 3
var current_matches: int = 0

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
	generate_runes() # Generate runes

	if Global.level == 1:
		_on_start_game()

func _on_start_game() -> void:
	show()
	animation_player.play("appear")

func generate_runes() -> void:
	if rune_config.runes.is_empty():
		push_error("No runes available in RuneConfig")
		return

	# Get all rune positions
	var rune_positions: Array[Node] = get_node("Runes").get_children()
	if rune_positions.is_empty():
		push_error("No rune positions found in Level1")
		return

	# Clean up existing runes
	for position in rune_positions:
		for child in position.get_children():
			child.queue_free()

	if not Global.testing:
		rune_positions.shuffle()

	# Generate all runes including the match rune
	var all_runes: Array[BaseRune] = rune_config.create_random_runes(rune_positions.size())
	if all_runes.is_empty():
		push_error("Failed to create runes")
		return

	# Get the first rune as our match target and place it on the pedestal
	match_rune = all_runes[0]
	Events.place_on_pedistal.emit(match_rune)

	# Place all runes in positions
	for i in range(all_runes.size()):
		all_runes[i]._is_bobbing = true
		rune_positions[i].add_child(all_runes[i])

func _on_level_1_completed() -> void:
	audio_stream_player_3d.play()

func _on_rune_matched() -> void:
	current_matches += 1
	if current_matches >= matches_required:
		Events.level_1_completed.emit()
	else:
		# Generate new runes for the next match
		generate_runes()
		# Emit a signal to update the progress display
		Events.update_match_progress.emit(current_matches, matches_required)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "appear":
		Events.level_1_instructions.emit()

	if anim_name == "fade":
		match_rune.queue_free()
		Events.level_2_load.emit()
		collision_shape_3d.disabled = true
		hide()

func _on_audio_stream_player_3d_finished() -> void:
	animation_player.play("fade")

func _on_restart_level() -> void:
	current_matches = 0
	animation_player.play("fade")
