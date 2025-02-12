@tool
class_name PickableCrystal
extends XRToolsPickable

var magic_crystal: bool = false
var breakable: bool = false

@onready var break_sound: AudioStreamPlayer3D = $BreakSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.level_3_completed.connect(_on_level_3_completed)


func _on_dropped(_pickable: Variant) -> void:
	freeze = false


func _on_body_entered(_body: Node) -> void:
	if breakable:
		hide()
		if not break_sound.playing:
			break_sound.play()


func _on_break_sound_finished() -> void:
	queue_free()


func _on_level_3_completed() -> void:
	if visible and not magic_crystal:
		hide()
