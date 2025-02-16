@tool
class_name Staff
extends XRToolsPickable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enabled = false
	Events.spawn_staff_head.connect(_on_spawn_staff_head)


func _on_spawn_staff_head() -> void:
	print("Enable staff")
	enabled = true
