@tool
class_name BaseRune
extends XRToolsPickable

@export var rune_name: String
@export var rune_mesh: ArrayMesh
@export var hover_height: float = 0.2  # How high to hover off the ground
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _initial_position: Vector3
var _is_hovering: bool = false

func _ready() -> void:
	Events.level_1_completed.connect(_on_level_1_completed)
	highlight_updated.connect(_on_highlight_updated)
	_initial_position = global_position

	# Set the mesh if it exists
	if rune_mesh and has_node("CollisionShape3D/MeshInstance3D"):
		$CollisionShape3D/MeshInstance3D.mesh = rune_mesh

func _on_dropped(_pickable: Variant) -> void:
	freeze = false
	_initial_position = global_position  # Update initial position when dropped

func _on_level_1_completed() -> void:
	freeze = false

func _on_highlight_updated(_pickable, enable: bool) -> void:
	if enable and not _is_hovering:
		# First hover up
		_is_hovering = true
		var tween = create_tween()
		tween.tween_property(self, "global_position:y",
			_initial_position.y + hover_height, 0.3
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_callback(func(): animation_player.play("bob"))
	elif not enable and _is_hovering:
		# Stop bobbing and return to ground
		animation_player.stop()
		_is_hovering = false
		var tween = create_tween()
		tween.tween_property(self, "global_position:y",
			_initial_position.y, 0.3
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
