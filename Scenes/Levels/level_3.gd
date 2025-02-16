class_name Level3
extends Node3D

const PICKABLE_CRYSTAL = preload("res://Scenes/Game/Crystals/pickable_crystal.tscn")

var magic_crystal: RigidBody3D

@onready var crystals: Node = $Crystals
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var fail_sound: AudioStreamPlayer3D = $FailSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()
	Global.level = 3
	animation_player.play("appear")
	place_crystals()

	Events.level_3_completed.connect(_on_level_3_completed)
	Events.wrong_crystal.connect(_on_wrong_crystal)
	Events.restart_level.connect(_on_restart_level)


func place_crystals() -> void:
	var crystal_i: int = 0
	var crystal_positions: Array[Node] = crystals.get_children()

	if not Global.testing:
		crystal_positions.shuffle()

	for crystal_position: Marker3D in crystal_positions:
		var _crystal: PickableCrystal = PICKABLE_CRYSTAL.instantiate()
		if crystal_i == 0:
			_crystal.magic_crystal = true
			magic_crystal = _crystal
		crystal_position.add_child(_crystal)

		crystal_i += 1


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		# magic_crystal.queue_free()
		Events.level_4_load.emit()
		hide()


func _on_audio_stream_player_3d_finished() -> void:
	animation_player.play("fade")


func _on_level_3_completed() -> void:
	audio_stream_player_3d.play()


func _on_wrong_crystal() -> void:
	fail_sound.play()


func _on_restart_level() -> void:
	animation_player.play("fade")
