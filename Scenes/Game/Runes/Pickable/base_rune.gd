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
## Whether the rune is actively bobbing up and down
var _is_bobbing: bool = false
var _was_bobbing: bool = false
## Accumulated time for bob calculation
var _time: float = 0.0
## Previous frame's velocity for momentum preservation
var _last_velocity: Vector3 = Vector3.ZERO
## Random offset for bob timing to prevent synchronization
var _bob_phase_offset: float = 0.0
## Random frequency modifier to make each rune slightly different
var _bob_frequency_modifier: float = 1.0
## Random amplitude modifier for varying bob heights
var _bob_amplitude_modifier: float = 1.0
## Random direction modifier (-1 or 1) for initial bob direction
var _bob_direction: float = 1.0
## Random hover height modifier
var _hover_height_modifier: float = 1.0

func _ready() -> void:
	Events.level_1_completed.connect(_on_level_1_completed)
	highlight_updated.connect(_on_highlight_updated)
	_initial_position = global_position
	freeze = false

	# Initialize random bobbing parameters
	_bob_phase_offset = randf_range(0, PI * 2.0)  # Random phase offset (0 to 2π)
	_bob_frequency_modifier = randf_range(0.1, 10.0)  # Frequency variation
	_bob_amplitude_modifier = randf_range(0.5, 10.0)  # Amplitude variation
	_bob_direction = 1.0 if randf() > 0.5 else -1.0  # Random initial direction
	_hover_height_modifier = randf_range(0.5, 2.0)  # 50% to 200% base height variation
	# Set the mesh if it exists
	if rune_mesh and has_node("CollisionShape3D/MeshInstance3D"):
		$CollisionShape3D/MeshInstance3D.mesh = rune_mesh

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if _is_bobbing:
		_apply_hover_bobbing(state)
	else:
		_apply_natural_fall(state)

func _apply_hover_bobbing(state: PhysicsDirectBodyState3D) -> void:
	_time += state.step

	# Calculate the target height including bobbing with random modifiers
	var bob_phase = bob_frequency * _bob_frequency_modifier * _time * PI * 2.0 + _bob_phase_offset
	var bob_offset = bob_amplitude * _bob_amplitude_modifier * _bob_direction * sin(bob_phase)
	var target_height = _initial_position.y + (hover_height * _hover_height_modifier) + bob_offset

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


func _apply_natural_fall(state: PhysicsDirectBodyState3D) -> void:
	# Apply damping to horizontal movement
	var damped_velocity = state.linear_velocity
	damped_velocity.x *= damping
	damped_velocity.z *= damping
	state.linear_velocity = damped_velocity


func _on_highlight_updated(_pickable, enable: bool) -> void:
	if enable and not is_picked_up():
		_is_bobbing = true
		_time = 0.0  # Reset time for consistent bobbing
	elif not enable:
		_is_bobbing = false

	_was_bobbing = _is_bobbing

func _on_dropped(_pickable: Variant) -> void:
	freeze = false
	_initial_position = global_position

func _on_level_1_completed() -> void:
	freeze = false
