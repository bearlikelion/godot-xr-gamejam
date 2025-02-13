class_name HatSnapZone
extends XRToolsSnapZone


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.chest_opened.connect(_on_chest_opened)


func _on_chest_opened() -> void:
	enabled = true


func _on_has_picked_up(what: Variant) -> void:
	if what is WizardHat:
		what.reparent(get_tree().get_first_node_in_group("base"))
