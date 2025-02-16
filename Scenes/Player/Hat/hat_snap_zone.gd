@tool
class_name HatSnapZone
extends XRToolsSnapZone

var wore_hat: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.chest_opened.connect(_on_chest_opened)


func _on_chest_opened() -> void:
	enabled = true


func _on_has_picked_up(what: Variant) -> void:
	if what is WizardHat and not wore_hat:
		wore_hat = true
		# what.reparent(get_tree().get_first_node_in_group("base"), true)
		pick_up(what)
		Events.player_equipped_hat.emit()
