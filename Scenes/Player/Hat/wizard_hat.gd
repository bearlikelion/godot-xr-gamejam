@tool
class_name WizardHat
extends XRToolsPickable

@export var animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	picked_up.connect(_on_picked_up)


func _on_picked_up(_pickable: Variant) -> void:
	if animation_player:
		animation_player.stop()
		reparent(get_tree().get_first_node_in_group("base"), true)
		_grab_driver.reparent(get_tree().get_first_node_in_group("base"), true)

	print("Player picked up hat")
	Events.grabbed_hat.emit()
