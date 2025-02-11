class_name CrystalArea
extends Area3D

var delay_time: float = randf_range(0.25, 5.0)

@onready var crystal_shatter: AudioStreamPlayer3D = $CrystalShatter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_exited.connect(_on_body_exited)
	Events.level_3_completed.connect(_on_level_3_completed)


func destroy_crystal() -> void:
	hide()
	crystal_shatter.play()


func _on_body_exited(body: Node3D) -> void:
	if body is PickableCrystal:
		destroy_crystal()


func _on_level_3_completed() -> void:
	if visible:
		delay_time = snappedf(delay_time, 0.25)
		print("Crystal destroy delay %s" % delay_time)

		await get_tree().create_timer(delay_time).timeout
		destroy_crystal()
