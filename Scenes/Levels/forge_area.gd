extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitoring = false
	Events.staff_head_connected.connect(_on_staff_head_connected)


func _on_staff_head_connected() -> void:
	monitoring = true


func _on_body_entered(body: Node3D) -> void:
	print("Body entered forge: %s" % body.name)
	if body.is_in_group("staff_head"):
		print("Staff forged")
		Events.staff_forged.emit()
