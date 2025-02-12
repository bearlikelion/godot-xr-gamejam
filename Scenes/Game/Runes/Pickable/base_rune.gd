@tool
class_name BaseRune
extends XRToolsPickable

@export var rune_name: String
@export var rune_mesh: ArrayMesh
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# func _init(p_rune_name: String, p_rune_mesh_path: String) -> void:
# 	rune_name = p_rune_name
# 	rune_mesh = load(p_rune_mesh_path) as ArrayMesh

func _ready() -> void:
	Events.level_1_completed.connect(_on_level_1_completed)
	highlight_updated.connect(_on_highlight_updated)

	# Set the mesh if it exists
	if rune_mesh and has_node("CollisionShape3D/MeshInstance3D"):
		$CollisionShape3D/MeshInstance3D.mesh = rune_mesh

func _on_dropped(_pickable: Variant) -> void:
	freeze = false

func _on_level_1_completed() -> void:
	freeze = false

func _on_highlight_updated(_pickable, enable: bool) -> void:
	if enable:
		animation_player.play("bob")
	else:
		animation_player.stop()
