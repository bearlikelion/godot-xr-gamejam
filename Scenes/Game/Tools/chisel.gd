@tool
class_name Chisel
extends XRToolsPickable

@export var magic_chisel: bool = false

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.spawn_staff_head.connect(_on_spawn_staff_head)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is PickableCrystal:
		audio_stream_player_3d.play()
		if magic_chisel:
			print("Correct hit!")
			body.crystal_hit()
		else:
			if mesh_instance_3d.material_overlay == null:
				var wrong_material: StandardMaterial3D = StandardMaterial3D.new()
				wrong_material.albedo_color = Color(1.0, 0.0, 0.0, 0.33)
				mesh_instance_3d.material_overlay = wrong_material

			print("Wrong tool for the job")


func _on_dropped(_pickable: Variant) -> void:
	if not magic_chisel and freeze:
		freeze = false


func _on_spawn_staff_head() -> void:
	if magic_chisel:
		freeze = false
