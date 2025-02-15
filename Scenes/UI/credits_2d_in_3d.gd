extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Events.show_credits.connect(_on_show_credits)


func _on_show_credits() -> void:
	show()
