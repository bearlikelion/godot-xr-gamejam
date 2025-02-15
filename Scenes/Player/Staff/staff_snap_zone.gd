@tool
class_name StaffSnapZone
extends XRToolsSnapZone


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_has_picked_up(what: Variant) -> void:
	if what is StaffHead:
		what.reparent(get_parent())
		await get_tree().create_timer(1.0).timeout
		what._grab_driver.discard()
		await get_tree().create_timer(1.0).timeout
		enabled = false
		what.enabled = false
		Events.staff_head_connected.emit()
