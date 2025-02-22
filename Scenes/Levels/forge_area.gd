extends Area3D
@onready var forge_audio_stream_player_3d: AudioStreamPlayer3D = $ForgeAudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#monitoring = false
	#Events.staff_head_connected.connect(_on_staff_head_connected)
	pass


func _on_staff_head_connected() -> void:
	monitoring = true


func _on_body_entered(body: Node3D) -> void:
	print("Body entered forge: %s" % body.name)

	if body is XRToolsPickable:
		forge_audio_stream_player_3d.pitch_scale = randf_range(1, 1.2)
		forge_audio_stream_player_3d.play()

	if body is StaffHead:
		print("Staff forged")
		body.forge_cook()
		Events.staff_forged.emit()
		Events.rumble.emit("LEFT", "FORGE")
		Events.rumble.emit("RIGHT", "FORGE")


func _on_body_exited(body: Node3D) -> void:
	print("Exited Forge: %s" % body.name)
	if body is StaffHead:
		body.chill_out()
		print("Changing staff color to blue")
