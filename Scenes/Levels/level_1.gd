class_name Level1
extends StaticBody3D

var match_rune: BaseRune

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@export var rune_config: RuneConfig

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.start_game.connect(_on_start_game)
	Events.level_1_completed.connect(_on_level_1_completed)


func _on_start_game() -> void:
	show()
	generate_runes() # Generate runes
	animation_player.play("appear")


func generate_runes() -> void:
	# Wait for rune resources to be loaded if needed
	if not rune_config.runes:
		await rune_config.rune_resources_loaded

	# Get all available rune names
	var rune_names = rune_config.runes.keys()
	rune_names.shuffle()

	# Select a random rune to match
	var rune_to_match_name = rune_names[0]
	var rune_to_match = rune_config.runes[rune_to_match_name]
	Events.place_on_pedistal.emit(rune_to_match.mesh)

	# Get all rune positions and shuffle them
	var rune_positions: Array[Node] = get_node("Runes").get_children()
	rune_positions.shuffle()

	# Place the matching rune at the first position
	var first_position: Marker3D = rune_positions.front()
	match_rune = BaseRune.new()
	match_rune.rune_mesh = rune_to_match.mesh
	first_position.add_child(match_rune)
	rune_names.erase(rune_to_match_name)

	# Fill remaining positions with random runes
	for rune_position: Marker3D in rune_positions.slice(1):
		rune_names.shuffle()
		var random_rune_name = rune_names[0]
		var random_rune = rune_config.runes[random_rune_name]
		var pickable_rune = BaseRune.new()
		pickable_rune.rune_mesh = random_rune.mesh
		rune_position.add_child(pickable_rune)


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
