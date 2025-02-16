@tool
extends XRToolsPickable

@onready var shattersfx: AudioStreamPlayer3D = $ShatterSFX


func shatter() -> void:
	print("IT BROKE")
	shattersfx.pitch_scale = randf_range(1.0,1.5)
	shattersfx.play()
	Events.grow_potion_used.emit()
	hide()


func _on_dropped(_pickable: Variant) -> void:
	freeze = false


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area is CrowdArea:
		print("HE GREW BIGGER")
		var random_scale: float = randf_range(-1,1)
		snappedf(random_scale,0.25)
		area.scale_character(random_scale)
		shatter()
	else:
		print("a spillage all over the floor")
		#shatter()
