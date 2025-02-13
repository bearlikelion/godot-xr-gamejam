@tool
class_name WizardHat
extends XRToolsPickable

@export var animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	picked_up.connect(_on_picked_up)


func _on_picked_up() -> void:
	if animation_player:
		animation_player.stop()

	print("Player picked up hat")
	Events.grabbed_hat.emit()
