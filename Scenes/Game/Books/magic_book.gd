@tool
class_name MagicBook
extends XRToolsPickable

@export var book_name: String

var picked: bool = false


func _ready() -> void:
	Events.level_2_completed.connect(_on_level_2_completed)


func _on_dropped(_pickable: Variant) -> void:
	picked = true
	freeze = false


func _on_level_2_completed() -> void:
	freeze = false
	if picked:
		gravity_scale = -1.0
