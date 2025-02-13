@tool
class_name BaseRune
extends XRToolsPickable

# Rune Configuration
@export_group("Rune Properties")
## The name identifier for this rune
@export var rune_name: String
## The mesh to use for this rune's visual representation
@export var rune_mesh: ArrayMesh

# Hover and Bob Configuration
@export_group("Hover Properties")
## Height above initial position to hover
@export var hover_height: float = 0.2
## Spring force strength for maintaining hover height
@export var spring_strength: float = 20.0
## Damping factor for horizontal movement (0-1)
@export var damping: float = 0.8

@export_group("Bob Properties")
## Maximum distance to bob up and down
@export var bob_amplitude: float = 0.05
## Frequency of bobbing motion (cycles per second)
@export var bob_frequency: float = 2.0
## Time to maintain upward momentum when stopping hover
@export var hover_timeout: float = 0.5

# State Variables
## Starting position of the rune
var _initial_position: Vector3
## Current hover state
var _is_hovering: bool = false
## Whether the rune is transitioning from hover to fall
var _is_falling: bool = false
## Accumulated time for bob calculation
var _time: float = 0.0
## Timer for controlling hover-to-fall transition
var _hover_timer: float = 0.0
## Previous frame's velocity for momentum preservation
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
