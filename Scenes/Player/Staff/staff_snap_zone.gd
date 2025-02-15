@tool
class_name StaffSnapZone
extends XRToolsSnapZone


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_has_picked_up(what: Variant) -> void:
	if what is StaffHead:
		what.reparent(self)
		what.enabled = false
		enabled = false
		Events.staff_head_connected.emit()
