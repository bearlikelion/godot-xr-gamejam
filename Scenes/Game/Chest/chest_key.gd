@tool
class_name ChestKey
extends XRToolsPickable

@export var golden_key: bool = false


func _on_dropped(_pickable: Variant) -> void:
	freeze = false
