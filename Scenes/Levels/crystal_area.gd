class_name CrystalArea
extends Area3D

@onready var crystal_shatter: AudioStreamPlayer3D = $CrystalShatter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_exited.connect(_on_body_exited)


func _on_body_exited(body: Node3D) -> void:
	if body is PickableCrystal:
		hide()
		crystal_shatter.play()
