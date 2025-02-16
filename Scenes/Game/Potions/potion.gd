@tool
class_name Potion
extends XRToolsPickable

@onready var pouring_sfx: AudioStreamPlayer3D = $PouringSFX

@export_enum("RED", "BLUE") var potion_color: String
@export var correct_potion: bool = false
@export var combining_potion: bool = false

@export_group("Liquid Simulation")
@export_range (0.0, 1.0, 0.001) var liquid_mobility: float = 0.1

@export var springConstant: int = 200
@export var reaction: int = 4
@export var dampening: int = 3

var blue_potion: bool = false
var red_potion: bool = false
var correct_potions: int = 0

var vel: float = 0.0
var accell: Vector2
var coeff: Vector2
var coeff_old: Vector2
var coeff_old_old: Vector2
var liquidShaderMaterial: ShaderMaterial

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var pos1 : Vector3 = get_global_transform().origin
@onready var pos2 : Vector3 = pos1
@onready var pos3 : Vector3 = pos2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if combining_potion:
		enabled = false

	liquidShaderMaterial = mesh_instance_3d.get_surface_override_material(1)


func _physics_process(delta: float) -> void:
	if liquidShaderMaterial:
		var accell_3d:Vector3 = (pos3 - 2 * pos2 + pos1) * 3600.0
		pos1 = pos2
		pos2 = pos3
		pos3 = get_global_transform().origin + rotation
		accell = Vector2(accell_3d.x + accell_3d.y, accell_3d.z + accell_3d.y)
		coeff_old_old = coeff_old
		coeff_old = coeff
		coeff = (-springConstant * coeff_old - reaction * accell) / 3600.0 + 2 * coeff_old - coeff_old_old - delta * dampening * (coeff_old - coeff_old_old)
		if not correct_potion:
			liquidShaderMaterial.set_shader_parameter("fill_amount", 1.0)

		liquidShaderMaterial.set_shader_parameter("coeff", coeff*liquid_mobility)
		if (pos1.distance_to(pos3) < 0.01):
			vel = clamp (vel-delta*1.0,0.0,1.0)
		else:
			vel = 1.0
		liquidShaderMaterial.set_shader_parameter("vel", vel)


func _on_combining_area_area_entered(area: Area3D) -> void:
	if area.get_parent() is Potion:
		var potion: Potion = area.get_parent()
		if potion.correct_potion and potion.potion_color == "RED" and not red_potion:
			pouring_sfx.pitch_scale = 1.0
			pouring_sfx.play()
			red_potion = true
			var red_material: StandardMaterial3D = StandardMaterial3D.new()
			red_material.albedo_color = Color.RED
			mesh_instance_3d.set_surface_override_material(1, red_material)
			correct_potions += 1

		if potion.correct_potion and potion.potion_color == "BLUE" and not blue_potion:
			pouring_sfx.pitch_scale = 1.0
			pouring_sfx.play()
			blue_potion = true
			var blue_material: StandardMaterial3D = StandardMaterial3D.new()
			blue_material.albedo_color = Color.BLUE
			mesh_instance_3d.set_surface_override_material(1, blue_material)
			correct_potions += 1

		if correct_potions == 2:
			pouring_sfx.pitch_scale = 1.3
			pouring_sfx.play()
			print("PLAYER GOT IT CORRECT WIN LEVEL")
			var purple_material: StandardMaterial3D = StandardMaterial3D.new()
			purple_material.albedo_color = Color.PURPLE
			mesh_instance_3d.set_surface_override_material(1, purple_material)
			await get_tree().create_timer(2.0).timeout
			Events.level_6_completed.emit()

		if not potion.correct_potion:
			pouring_sfx.pitch_scale = 0.8
			pouring_sfx.play()
			var black_material: StandardMaterial3D = StandardMaterial3D.new()
			black_material.albedo_color = Color.BLACK
			mesh_instance_3d.set_surface_override_material(1, black_material)
			Events.reset_potions.emit()
			red_potion = false
			blue_potion = false
			correct_potions = 0
			await get_tree().create_timer(2.0).timeout
			var white_material: StandardMaterial3D = StandardMaterial3D.new()
			white_material.albedo_color = Color.WHITE
			mesh_instance_3d.set_surface_override_material(1, white_material)
			return


func _on_dropped(_pickable: Variant) -> void:
	freeze = false
