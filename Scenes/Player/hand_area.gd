extends Area3D

@export_enum("LEFT", "RIGHT") var hand: String

func _on_body_entered(body: Node3D) -> void:
	if body is XRToolsPickable:
		print("Body entered hand area: %s" % body.name)
		Events.rumble.emit(hand, body.name)
