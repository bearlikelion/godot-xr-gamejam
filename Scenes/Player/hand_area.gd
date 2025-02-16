extends Area3D

@export_enum("LEFT", "RIGHT") var hand: String

func _on_body_entered(body: Node3D) -> void:
	print("Body entered %s hand %s" % [hand, body.name])
	if body is XRToolsPickable and body.enabled:
		if body is PickableCrystal and body.breakable:
			body.crystal_break()

		if body is ChestKey:
			body.remove_shading()

		# print("Body entered hand area: %s" % body.name)
		Events.rumble.emit(hand, body.name)
