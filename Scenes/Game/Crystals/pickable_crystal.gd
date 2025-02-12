@tool
class_name PickableCrystal
extends XRToolsPickable

const STAFF_HEAD = preload("res://Scenes/Player/Staff/staff_head.tscn")

var magic_crystal: bool = false
var breakable: bool = false
var hits: int = 0

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


func crystal_hit() -> void:
	hits += 1
	scale -= Vector3(0.25, 0.25, 0.25)
