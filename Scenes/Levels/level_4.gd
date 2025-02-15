class_name Level4
extends StaticBody3D

const CHISEL = preload("res://Scenes/Game/Tools/chisel.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var chisels: Node = $Chisels



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()
	Global.level = 4
	animation_player.play("appear")
	spawn_chisel()
	Events.level_4_completed.connect(_on_level_4_completed)
	var podium_snap_zone: XRToolsSnapZone = get_tree().get_first_node_in_group("podium_snap_zone")
	if podium_snap_zone: 
		podium_snap_zone.enabled = true
		print("podium snap zone is oke doke") 
	var magic_crystal: PickableCrystal = get_tree().get_first_node_in_group("magic_crystal")
	if magic_crystal:
		magic_crystal.enabled = true
		print("magic crystal is oke doke")


func spawn_chisel() -> void:
	var chisel_posisitions: Array[Node] = chisels.get_children()
	if not Global.testing:
		chisel_posisitions.shuffle()
	var magic_chisel: Chisel = CHISEL.instantiate()
	chisel_posisitions.pop_front().add_child(magic_chisel)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		Events.level_5_load.emit()
		hide()


func _on_audio_stream_player_3d_finished() -> void:
	animation_player.play("fade")


func _on_level_4_completed() -> void:
	audio_stream_player_3d.play()
