@tool
class_name AnvilSnapZone
extends XRToolsSnapZone


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_has_picked_up(what: Variant) -> void:
	print("Anvil Picked Up: %s" % what)
	if what.is_in_group("magic_crystal"):
		Events.find_tool.emit()
