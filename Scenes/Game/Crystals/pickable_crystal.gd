@tool
class_name PickableCrystal
extends XRToolsPickable

var magic_crystal: bool = false
var breakable: bool = false

@onready var break_sound: AudioStreamPlayer3D = $BreakSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_dropped(_pickable: Variant) -> void:
	freeze = false


func _on_body_entered(_body: Node) -> void:
	if breakable:
		hide()
		break_sound.play()


func _on_break_sound_finished() -> void:
	queue_free()
