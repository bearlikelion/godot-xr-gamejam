@tool
class_name Potion
extends XRToolsPickable

@export_enum("RED", "BLUE") var potion_color: String
@export var correct_potion: bool = false
@export var combining_potion: bool = false

var blue_potion: bool = false
var red_potion: bool = false
var correct_potions: int = 0

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if combining_potion:
		enabled = false


func _on_combining_area_area_entered(area: Area3D) -> void:
	if area.get_parent() is Potion:
		var potion: Potion = area.get_parent()
		if potion.correct_potion and potion.potion_color == "RED" and not red_potion:
			red_potion = true
			var red_material: StandardMaterial3D = StandardMaterial3D.new()
			red_material.albedo_color = Color.RED
			mesh_instance_3d.set_surface_override_material(1, red_material)
			correct_potions += 1

		if potion.correct_potion and potion.potion_color == "BLUE" and not blue_potion:
			blue_potion = true
			var blue_material: StandardMaterial3D = StandardMaterial3D.new()
			blue_material.albedo_color = Color.BLUE
			mesh_instance_3d.set_surface_override_material(1, blue_material)
			correct_potions += 1

		if correct_potions == 2:
			print("PLAYER GOT IT CORRECT WIN LEVEL")
			var purple_material: StandardMaterial3D = StandardMaterial3D.new()
			purple_material.albedo_color = Color.PURPLE
			mesh_instance_3d.set_surface_override_material(1, purple_material)
			Events.level_6_completed.emit()

		if not potion.correct_potion:
			var black_material: StandardMaterial3D = StandardMaterial3D.new()
			black_material.albedo_color = Color.BLACK
			mesh_instance_3d.set_surface_override_material(1, black_material)
			Events.reset_potions.emit()
			red_potion = false
			blue_potion = false
			await get_tree().create_timer(2.0).timeout
			var white_material: StandardMaterial3D = StandardMaterial3D.new()
			white_material.albedo_color = Color.WHITE
			mesh_instance_3d.set_surface_override_material(1, white_material)
			return

func _on_dropped() -> void:
	freeze = false
