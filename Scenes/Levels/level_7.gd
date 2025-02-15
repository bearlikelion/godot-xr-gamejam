class_name Level7
extends Node3D

const GOLD_KEY = preload("res://Scenes/Game/Chest/gold_key.tscn")
const RUSTY_KEY = preload("res://Scenes/Game/Chest/rusty_key.tscn")

@onready var keys: Node = $Keys
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var you_are_a_wizard: AudioStreamPlayer = $YouAreAWizard


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	place_keys()
	Global.level = 7
	Events.player_equipped_hat.connect(_on_equipped_hat)
	animation_player.play("appear")
	Events.restart_level.connect(_on_restart_level)


func place_keys() -> void:
	var keys_placed: int = 0
	var key_positions: Array[Node] = keys.get_children()

	if not Global.testing:
		key_positions.shuffle()

	for _key_pos: Marker3D in key_positions:
		if keys_placed == 0:
			_key_pos.add_child(GOLD_KEY.instantiate())
		else:
			_key_pos.add_child(RUSTY_KEY.instantiate())
		keys_placed += 1


func _on_equipped_hat() -> void:
	audio_stream_player_3d.play()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		Events.level_8_load.emit()


func _on_audio_stream_player_3d_finished() -> void:
	you_are_a_wizard.play()
	animation_player.play("fade")


func _on_restart_level() -> void:
	animation_player.play("fade")
