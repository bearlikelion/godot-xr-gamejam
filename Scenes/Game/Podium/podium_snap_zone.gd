@tool
class_name PodiumSnapZone
extends XRToolsSnapZone


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Events.start_game.connect(_on_start_game)
	Events.level_5_load.connect(_on_level_5_load)


func _on_start_game() -> void:
	show()


func _on_level_5_load() -> void:
	var staff_handle: Staff = get_tree().get_first_node_in_group("staff_handle")
	if staff_handle:
		staff_handle._grab_driver.discard()
		staff_handle.enabled = false

	drop_object()

	await get_tree().physics_frame

	if staff_handle:
		staff_handle.queue_free()
