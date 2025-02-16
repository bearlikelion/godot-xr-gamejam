@tool
class_name ChestKey
extends XRToolsPickable

@export var golden_key: bool = false

@onready var key: MeshInstance3D = $key


func _on_dropped(_pickable: Variant) -> void:
	freeze = false


func remove_shading() -> void:
	print("Key remove shading")
	key.material_override.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
