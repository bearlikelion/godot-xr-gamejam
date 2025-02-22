@tool
class_name PickableCrystal
extends XRToolsPickable

const STAFF_HEAD = preload("res://Scenes/Player/Staff/staff_head.tscn")

var magic_crystal: bool = false
var breakable: bool = false
var hits: int = 0

@onready var break_sound: AudioStreamPlayer3D = $BreakSound
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.level_3_completed.connect(_on_level_3_completed)

	if magic_crystal:
		mesh_instance_3d.material_override = null
		add_to_group("magic_crystal")


func _on_dropped(_pickable: Variant) -> void:
	freeze = false


func _on_body_entered(_body: Node) -> void:
	if breakable:
		crystal_break()


func crystal_break() -> void:
	hide()
	print("Wrong crystal broke")
	if not break_sound.playing:
		break_sound.play()


func _on_break_sound_finished() -> void:
	queue_free()


func _on_level_3_completed() -> void:
	if visible and not magic_crystal:
		hide()


func crystal_hit() -> void:
	hits += 1
	mesh_instance_3d.scale -= Vector3(0.1, 0.1, 0.1)
	Events.rumble.emit("LEFT", "CHISEL" + "_" + str(hits))
	Events.rumble.emit("RIGHT", "CHISEL" + "_" + str(hits))

	if hits > 2:
		var staff_head: RigidBody3D = STAFF_HEAD.instantiate()
		staff_head.transform = transform
		get_tree().get_first_node_in_group("base").add_child(staff_head)
		# get_tree().get_first_node_in_group("anvil_snap_zone").pick_up_object(staff_head)
		Events.spawn_staff_head.emit()
		_grab_driver.discard()
		queue_free()


func _on_picked_up(_pickable: Variant) -> void:
	if not magic_crystal:
		breakable = true
