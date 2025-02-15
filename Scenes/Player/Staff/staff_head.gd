@tool
class_name StaffHead
extends XRToolsPickable

var material_overlay: StandardMaterial3D
var is_cooling: bool = false

@onready var staff_head: MeshInstance3D = $"crystal blue/staff_001"

func _ready() -> void:
	material_overlay = staff_head.material_overlay
	material_overlay.albedo_color.a = 0.0


func _process(delta: float) -> void:
	if is_cooling:
		material_overlay.albedo_color.a = lerp(material_overlay.albedo_color.a, 0.0, (0.25*delta))
		staff_head.material_overlay = material_overlay
	if material_overlay.albedo_color.a <= 0.1:
		is_cooling = false


func forge_cook() -> void:
	material_overlay.albedo_color.a	= 1.0
	staff_head.material_overlay = material_overlay
	print("Set crystal to red. Crystal alpha: %s" % material_overlay.albedo_color.a)


func chill_out() -> void:
	is_cooling = true
	print("Crystal alpha: %s" % material_overlay.albedo_color.a)
