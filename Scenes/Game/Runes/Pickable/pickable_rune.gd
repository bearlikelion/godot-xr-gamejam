@tool
extends XRToolsPickable

@export var rune_name: String


func _ready() -> void:
	Events.level_1_completed.connect(_on_level_1_completed)


func _on_dropped(_pickable: Variant) -> void:
	freeze = false


func _on_level_1_completed() -> void:
	freeze = false
