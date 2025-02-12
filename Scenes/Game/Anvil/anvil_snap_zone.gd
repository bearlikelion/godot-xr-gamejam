@tool
class_name AnvilSnapZone
extends XRToolsSnapZone


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_has_picked_up(what: Variant) -> void:
	if what.is_in_group("staff_head"):
		Events.find_tool.emit()
