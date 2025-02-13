@tool
class_name BaseRune
extends XRToolsPickable

@export var rune_name: String
@export var rune_mesh: ArrayMesh
@export var hover_height: float = 0.2  # Target hover height
@export var spring_strength: float = 20.0  # How strongly to maintain hover height
@export var damping: float = 0.8  # How quickly to dampen movement (0-1)
@export var bob_amplitude: float = 0.05  # How much to bob
@export var bob_frequency: float = 2.0  # How fast to bob
@export var hover_timeout: float = 0.5  # How long to hover before falling

var _initial_position: Vector3
var _is_hovering: bool = false
var _is_falling: bool = false
var _time: float = 0.0
var _hover_timer: float = 0.0
var _last_velocity: Vector3 = Vector3.ZERO

func _ready() -> void:
	Events.level_1_completed.connect(_on_level_1_completed)
	highlight_updated.connect(_on_highlight_updated)
	_initial_position = global_position
	freeze = true  # Start frozen

	# Set the mesh if it exists
	if rune_mesh and has_node("CollisionShape3D/MeshInstance3D"):
		$CollisionShape3D/MeshInstance3D.mesh = rune_mesh

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if _is_hovering and not is_picked_up():
		_time += state.step

		# Calculate the target height including bobbing
		var bob_offset = bob_amplitude * sin(bob_frequency * _time * PI * 2.0)
		var target_height = _initial_position.y + hover_height + bob_offset

		# Calculate spring force based on distance from target
		var current_height = state.transform.origin.y
		var height_diff = target_height - current_height
		var spring_force = height_diff * spring_strength

		# Apply spring force and damping
		var force = Vector3.UP * spring_force
		state.apply_central_force(force)

		# Apply damping to horizontal movement (keep vertical movement for bouncing)
		var damped_velocity = state.linear_velocity
		damped_velocity.x *= damping
		damped_velocity.z *= damping
		state.linear_velocity = damped_velocity

		# Store last velocity for transition
		_last_velocity = state.linear_velocity

		# Keep the rune oriented upright
		state.transform.basis = Basis()
	elif _is_falling:
		_hover_timer += state.step

		# If moving upward or within hover timeout, maintain upward momentum
		if _last_velocity.y > 0 or _hover_timer < hover_timeout:
			# Gradually reduce upward velocity
			var current_velocity = state.linear_velocity
			current_velocity.y = _last_velocity.y * max(0, 1 - (_hover_timer / hover_timeout))
			state.linear_velocity = current_velocity
		else:
			# Start falling naturally
			_is_falling = false

		# Keep damping horizontal movement
		var damped_velocity = state.linear_velocity
		damped_velocity.x *= damping
		damped_velocity.z *= damping
		state.linear_velocity = damped_velocity

		# Keep upright while falling
		state.transform.basis = Basis()

func _on_highlight_updated(_pickable, enable: bool) -> void:
	if enable and not _is_hovering and not is_picked_up():
		_is_hovering = true
		_is_falling = false
		_time = 0.0  # Reset time for consistent bobbing
		freeze = false  # Allow physics to take effect
	elif not enable and _is_hovering:
		_is_hovering = false
		_is_falling = true
		_hover_timer = 0.0
		# Don't freeze - let physics continue for falling

func _on_dropped(_pickable: Variant) -> void:
	freeze = false
	_initial_position = global_position

func _on_level_1_completed() -> void:
	freeze = false
