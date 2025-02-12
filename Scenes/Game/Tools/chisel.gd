@tool
class_name Chisel
extends XRToolsPickable

@export var magic_chisel: bool = false

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is PickableCrystal:
		audio_stream_player_3d.play()
		if magic_chisel:
			print("Correct hit!")
			body.crystal_hit()
		else:
			print("Wrong tool for the job")


func _on_dropped(pickable: Variant) -> void:
	if not magic_chisel and freeze:
		freeze = false
