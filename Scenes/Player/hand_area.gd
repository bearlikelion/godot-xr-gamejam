extends Area3D
class_name PlayerHand

@export_enum("LEFT", "RIGHT") var hand: String

func _on_body_entered(body: Node3D) -> void:
	if body is XRToolsPickable and body.enabled:
		if body is PickableCrystal and body.breakable:
			body.crystal_break()

		# print("Body entered hand area: %s" % body.name)
		Events.rumble.emit(hand, body.name)
