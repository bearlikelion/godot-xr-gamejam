@tool
class_name Chisel
extends XRToolsPickable

@export var magic_chisel: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("Chishel hit %s" % body.name)
	if body is PickableCrystal:
		if magic_chisel:
			print("Correct hit!")
			body.crystal_hit()
		else:
			print("Wrong tool for the job")
