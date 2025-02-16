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

# Collision Configuration
@export_group("Collision Properties")
## The type of collision shape to use (0=Capsule, 1=Cylinder, 2=Box, 3=Sphere)
@export_enum("Capsule", "Cylinder", "Box", "Sphere") var collision_shape_type: int = 0
## The radius/width of the collision shape
@export var collision_radius: float = 0.1
## The height of the collision shape (for capsule/cylinder)
@export var collision_height: float = 0.2
## Whether to automatically size collision shape based on mesh bounds
@export var auto_size_collision: bool = true

# Materials
@export_group("Materials")
@export var rune_icon_material: StandardMaterial3D = preload("res://Shaders/rune_icon_glow.tres")
@export var faded_out_rune_icon_material: StandardMaterial3D = preload("res://Shaders/faded_rune_icon_glow.tres")

# Sound Configuration
@export_group("Sound Effects")
## Directory containing activation sounds (when rune is placed correctly)
const ACTIVATION_SOUND_TYPE: String = "activation"
## Directory containing deactivation sounds (when rune is removed)
const DEACTIVATION_SOUND_TYPE: String = "deactivation"
## Directory containing hover sounds (while rune is bobbing)
const HOVER_SOUND_TYPE: String = "hover"

# State Variables
## Starting position of the rune
var _initial_position: Vector3
## Whether the rune is actively bobbing up and down
var _is_bobbing: bool = false
var _was_bobbing: bool = false  # TODO is _was_bobbing needed?? Not being used
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

# Node references
@onready var _mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var _audio_player: AudioStreamPlayer3D = $AudioPlayer3D
@onready var _hover_audio_player: AudioStreamPlayer3D = $HoverAudioPlayer3D

# Sound randomizers
var _activation_randomizer: AudioStreamRandomizer
var _deactivation_randomizer: AudioStreamRandomizer
var _hover_randomizer: AudioStreamRandomizer

func _ready() -> void:
	Events.level_1_completed.connect(_on_level_1_completed)
	highlight_updated.connect(_on_highlight_updated)
	animation_player.animation_finished.connect(_on_fade_finished)
	picked_up.connect(_on_picked_up)  # Connect pickup signal
	_initial_position = global_position

	# Initialize random bobbing parameters
	_bob_phase_offset = randf_range(0, PI * 2.0)  # Random phase offset (0 to 2π)
	_bob_frequency_modifier = randf_range(0.1, 10.0)  # Frequency variation
	_bob_amplitude_modifier = randf_range(0.5, 10.0)  # Amplitude variation
	_bob_direction = 1.0 if randf() > 0.5 else -1.0  # Random initial direction
	_hover_height_modifier = randf_range(0.5, 2.0)  # 50% to 200% base height variation

	# Initialize audio player settings
	if _audio_player and _hover_audio_player:
		# Configure main audio player settings
		_audio_player.max_distance = 20.0  # Maximum distance to hear the sound
		_audio_player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_SQUARE_DISTANCE
		_audio_player.unit_size = 3.0  # Scale for distance calculations
		_audio_player.max_db = 0.0  # Maximum volume
		_audio_player.panning_strength = 1.0  # Full 3D panning

		# Configure hover audio player settings
		_hover_audio_player.max_distance = 20.0  # Maximum distance to hear the sound
		_hover_audio_player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_SQUARE_DISTANCE
		_hover_audio_player.unit_size = 2.0  # Scale for distance calculations
		_hover_audio_player.panning_strength = 1.0  # Full 3D panning
		_hover_audio_player.stream_paused = false  # Ensure not paused

		# Get cached randomizers from SoundManager
		_activation_randomizer = RuneSoundManager.get_rune_randomizer(ACTIVATION_SOUND_TYPE)
		_deactivation_randomizer = RuneSoundManager.get_rune_randomizer(DEACTIVATION_SOUND_TYPE)
		_hover_randomizer = RuneSoundManager.get_rune_randomizer(HOVER_SOUND_TYPE)

		if Global.testing:
			print("[BaseRune] Audio players initialized")
			print("[BaseRune] Hover randomizer exists: ", _hover_randomizer != null)

	# Initialize audio player settings
	if _audio_player:
		# Get cached randomizers from SoundManager
		_activation_randomizer = RuneSoundManager.get_rune_randomizer(ACTIVATION_SOUND_TYPE)
		_deactivation_randomizer = RuneSoundManager.get_rune_randomizer(DEACTIVATION_SOUND_TYPE)
		_hover_randomizer = RuneSoundManager.get_rune_randomizer(HOVER_SOUND_TYPE)

	# Set the mesh if it exists
	if rune_mesh:
		_mesh_instance.mesh = rune_mesh
		if auto_size_collision:
			_update_collision_shape_from_mesh()
		else:
			_update_collision_shape()

func _update_collision_shape_from_mesh() -> void:
	if not has_node("CollisionShape3D") or not rune_mesh:
		return

	var bounds := rune_mesh.get_aabb()
	collision_radius = max(bounds.size.x, bounds.size.z) * 0.5
	collision_height = bounds.size.y
	_update_collision_shape()

func _update_collision_shape() -> void:
	if not has_node("CollisionShape3D"):
		return

	var collision_node := $CollisionShape3D
	var new_shape: Shape3D

	match collision_shape_type:
		0: # Capsule
			var capsule := CapsuleShape3D.new()
			capsule.radius = collision_radius
			capsule.height = collision_height
			new_shape = capsule
		1: # Cylinder
			var cylinder := CylinderShape3D.new()
			cylinder.radius = collision_radius
			cylinder.height = collision_height
			new_shape = cylinder
		2: # Box
			var box := BoxShape3D.new()
			box.size = Vector3(collision_radius * 2, collision_height, collision_radius * 2)
			new_shape = box
		3: # Sphere
			var sphere := SphereShape3D.new()
			sphere.radius = collision_radius
			new_shape = sphere

	collision_node.shape = new_shape

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if _is_bobbing:
		_apply_hover_bobbing(state)
	else:
		_apply_natural_fall(state)

func _apply_hover_bobbing(state: PhysicsDirectBodyState3D) -> void:
	_time += state.step

	# Calculate the target height including bobbing with random modifiers
	var bob_phase: float = bob_frequency * _bob_frequency_modifier * _time * PI * 2.0 + _bob_phase_offset
	var bob_offset: float = bob_amplitude * _bob_amplitude_modifier * _bob_direction * sin(bob_phase)
	var target_height: float = _initial_position.y + (hover_height * _hover_height_modifier) + bob_offset

	# Calculate spring force based on distance from target
	var current_height: float = state.transform.origin.y
	var height_diff: float = target_height - current_height
	var spring_force: float = height_diff * spring_strength

	# Apply spring force and damping
	var force: Vector3 = Vector3.UP * spring_force
	state.apply_central_force(force)

	# Apply damping to horizontal movement (keep vertical movement for bouncing)
	var damped_velocity: Vector3 = state.linear_velocity
	damped_velocity.x *= damping
	damped_velocity.z *= damping
	state.linear_velocity = damped_velocity

	# Store last velocity for transition
	_last_velocity = state.linear_velocity


func _apply_natural_fall(state: PhysicsDirectBodyState3D) -> void:
	# Apply damping to horizontal movement
	var damped_velocity: Vector3 = state.linear_velocity
	damped_velocity.x *= damping
	damped_velocity.z *= damping
	state.linear_velocity = damped_velocity


func _on_highlight_updated(_pickable: Variant, enable: bool) -> void:
	if enable and not is_picked_up():
		_is_bobbing = true
		_time = 0.0  # Reset time for consistent bobbing
	elif not enable:
		_is_bobbing = false

	# Play sounds based on bobbing state transitions
	if not _was_bobbing and _is_bobbing:
		if Global.testing:
			print("[BaseRune] Started bobbing, playing activation sound")
		play_activation_sound()
		# Start hover sound after a short delay
		# await get_tree().create_timer(0.2).timeout
		_play_hover_sound()
	elif _was_bobbing and not _is_bobbing:
		if Global.testing:
			print("[BaseRune] Stopped bobbing, playing deactivation sound")
		_stop_hover_sound()  # Stop hover sound first
		play_deactivation_sound()

	_was_bobbing = _is_bobbing
	_set_rune_icon_material()

func play_activation_sound() -> void:
	if Global.testing:
		print("[BaseRune] Attempting to play activation sound")
		print("[BaseRune] Audio player exists: ", _audio_player != null)
		print("[BaseRune] Activation randomizer exists: ", _activation_randomizer != null)

	if _audio_player and _activation_randomizer:
		_audio_player.stream = _activation_randomizer
		_audio_player.pitch_scale = randf_range(0.9, 1.1)  # Slight pitch variation
		_audio_player.volume_db = randf_range(-2.0, 2.0)  # Slight volume variation
		_audio_player.play()
		if Global.testing:
			print("[BaseRune] Started playing activation sound")

func play_deactivation_sound() -> void:
	if Global.testing:
		print("[BaseRune] Attempting to play deactivation sound")
		print("[BaseRune] Audio player exists: ", _audio_player != null)
		print("[BaseRune] Deactivation randomizer exists: ", _deactivation_randomizer != null)

	if _audio_player and _deactivation_randomizer:
		_audio_player.stream = _deactivation_randomizer
		_audio_player.pitch_scale = randf_range(0.9, 1.1)  # Slight pitch variation
		_audio_player.volume_db = randf_range(-2.0, 2.0)  # Slight volume variation
		_audio_player.play()
		if Global.testing:
			print("[BaseRune] Started playing deactivation sound")

func _play_hover_sound() -> void:
	pass
	# if _hover_audio_player and _hover_randomizer:
	# 	_hover_audio_player.stream = _hover_randomizer
	# 	_hover_audio_player.pitch_scale = randf_range(0.95, 1.05)  # Subtle pitch variation for hover
	# 	_hover_audio_player.volume_db = randf_range(-5.0, -3.0)  # Quieter than activation/deactivation
	# 	# if not _hover_audio_player.playing:
	# 	# 	_hover_audio_player.play()

	# 	if Global.testing:
	# 		print("[BaseRune] Started playing hover sound")

func _stop_hover_sound() -> void:
	pass
	# if _hover_audio_player and _hover_audio_player.playing and _hover_audio_player.stream == _hover_randomizer:
	# 	_hover_audio_player.stop()
	# 	if Global.testing:
	# 		print("[BaseRune] Stopped hover sound")

func _set_rune_icon_material() -> void:
	if _mesh_instance:
		if _is_bobbing or is_picked_up():
			_mesh_instance.set_surface_override_material(1, rune_icon_material)
			return
		else:
			_mesh_instance.set_surface_override_material(1, faded_out_rune_icon_material)

func _on_dropped(_pickable: Variant) -> void:
	freeze = false
	_initial_position = global_position
	if Global.testing:
		print("[BaseRune] Rune dropped, checking if correctly placed")
	# TODO: Add logic to check if rune is correctly placed
	# For now, just play activation sound
	play_activation_sound()

func _on_level_1_completed() -> void:
	freeze = false

func fade_out() -> void:
	animation_player.play("Fade Out")

func fade_in() -> void:
	animation_player.play("Fade In")

func _on_fade_finished(anim_name: StringName) -> void:
	if anim_name == "Fade Out":
		Events.runes_faded_out.emit()
		queue_free()

func _on_picked_up(_pickable: Node3D) -> void:
	if Global.testing:
		print("[BaseRune] Rune picked up, playing deactivation sound")
	play_deactivation_sound()
