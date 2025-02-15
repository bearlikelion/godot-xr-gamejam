class_name RuneConfig
extends Node

## Configuration class for managing rune meshes and icons.
## Provides centralized access to rune resources.

# Directories containing the assets
const MESH_DIRECTORY: String = "res://Assets/Models/Runes/Rocks/Mesh/"
const ICON_DIRECTORY: String = "res://Assets/Models/Runes/Static/Mesh/"
const RUNE_SCENE_PATH: String = "res://Scenes/Game/Runes/Pickable/base_rune.tscn"

## Structure to hold rune resource paths
class RuneResources:
	var rune_name: String
	var mesh_path: String
	var icon_path: String

	func _init(in_rune_name: String, in_mesh_path: String, in_icon_path: String) -> void:
		rune_name = in_rune_name
		mesh_path = in_mesh_path
		icon_path = in_icon_path

## Dictionary mapping rune names to their resource paths
var runes: Dictionary[String, RuneResources] = {}
var _base_rune_scene: PackedScene

## Emitted when rune paths are validated
signal runes_validated

func _ready() -> void:
	_base_rune_scene = preload(RUNE_SCENE_PATH)
	if not _base_rune_scene:
		push_error("Failed to load base rune scene from: " + RUNE_SCENE_PATH)
		return

	var success: bool = validate_runes()
	if success:
		runes_validated.emit()

## Validates available runes without loading resources
## Returns true if successful, false if there was an error
func validate_runes() -> bool:
	var success: bool = true
	var mesh_paths: Dictionary = {}
	var icon_paths: Dictionary = {}

	# Scan for mesh paths
	success = success and _scan_directory(
		MESH_DIRECTORY,
		"runes_",
		mesh_paths
	)

	# Scan for icon paths
	success = success and _scan_directory(
		ICON_DIRECTORY,
		"runes icons_",
		icon_paths
	)

	# Only keep runes that have both mesh and icon
	for rune_name: String in mesh_paths:
		if icon_paths.has(rune_name):
			runes[rune_name] = RuneResources.new(
				rune_name,
				mesh_paths[rune_name],
				icon_paths[rune_name]
			)

	if runes.is_empty():
		success = false
		print("No complete rune sets (mesh + icon) found")

	return success

## Scans a directory for rune resources and stores their paths
## Returns true if successful, false if there was an error
func _scan_directory(directory: String, prefix: String, out_paths: Dictionary) -> bool:
	var success: bool = true

	var files: PackedStringArray = ResourceLoader.list_directory(directory)
	if files:
		for file_name in files:
			if file_name.begins_with(prefix) and file_name.ends_with(".res"):
				var rune_name: String = _extract_rune_name(file_name, prefix)
				var resource_path: String = directory + file_name
				out_paths[rune_name] = resource_path
	else:
		success = false
		print("Failed to open directory: " + directory)

	return success

## Helper function to extract rune name from filename
## Returns the rune name without prefix and extension
func _extract_rune_name(file_name: String, prefix: String) -> String:
	var prefix_length: int = prefix.length()
	var ext_length: int = ".res".length()
	return file_name.substr(prefix_length, file_name.length() - prefix_length - ext_length)

## Creates a new rune PackedScene with the specified rune name
## Returns null if the rune name doesn't exist or scene creation fails
func create_rune(rune_name: String) -> BaseRune:
	if not runes.has(rune_name) or not _base_rune_scene:
		return null

	# First instantiate the base scene to modify it
	var base_rune: BaseRune = _base_rune_scene.duplicate().instantiate()
	if not base_rune:
		return null

	# Set the properties
	base_rune.rune_name = rune_name
	base_rune.rune_mesh = load(runes[rune_name].mesh_path)

	# Update mesh and collision shape
	if base_rune.has_node("MeshInstance3D"):
		var mesh_instance: MeshInstance3D = base_rune.get_node("MeshInstance3D")
		mesh_instance.set_mesh(base_rune.rune_mesh)

		# Update collision shape based on the new mesh
		if base_rune.auto_size_collision:
			base_rune._update_collision_shape_from_mesh()
		else:
			base_rune._update_collision_shape()

	return base_rune

## Creates an array of random rune PackedScenes
## count: Number of runes to create
## Returns: Array of PackedScenes with configured runes
func create_random_runes(count: int) -> Array[BaseRune]:
	var result: Array[BaseRune] = []
	if runes.is_empty() or not _base_rune_scene:
		push_error("No runes available to create or base scene not loaded")
		return result

	# Get all available rune names and shuffle them
	var available_runes = runes.keys()
	available_runes.shuffle()

	# Create specified number of runes
	for i in range(count):
		if i >= available_runes.size():
			break

		var rune_name = available_runes[i]
		var rune = create_rune(rune_name)
		if rune:
			result.append(rune)

	return result

## Returns a list of all available rune names
## These runes are guaranteed to have both mesh and icon resources
func get_available_runes() -> Array[String]:
	return runes.keys()
