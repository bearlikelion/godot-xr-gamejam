class_name RuneConfig
extends Node

## Configuration class for managing rune meshes and icons.
## Provides centralized access to rune resources and ensures they are preloaded.

# Directories containing the assets
const MESH_DIRECTORY: String = "res://Assets/Models/Runes/Rocks/Mesh/"
const ICON_DIRECTORY: String = "res://Assets/Models/Runes/Static/Mesh/"
## Structure to hold rune resources
class RuneResources:
	var rune_name: String
	var mesh: ArrayMesh
	var icon: ArrayMesh

	func _init(rune_name: String, mesh_res: Resource, icon_res: Resource) -> void:
		rune_name = rune_name
		mesh = mesh_res
		icon = icon_res

## Dictionary mapping rune names to their resources
var runes: Dictionary[String, RuneResources] = {}

## Emitted when resources are loaded successfully
signal resources_loaded
## Emitted when there's an error loading resources
signal load_error(error_message: String)


func _ready() -> void:
	var load_success: bool = _load_resources()
	if load_success:
		resources_loaded.emit()

## Loads all rune resources into memory
func _load_resources() -> bool:
	var success: bool = true
	var mesh_resources: Dictionary = {}
	var icon_resources: Dictionary = {}
	# Load mesh resources
	success = success and _scan_directory(
		MESH_DIRECTORY,
		"runes_",
		mesh_resources,
		"ArrayMesh"
	)

	# Load icon resources
	success = success and _scan_directory(
		ICON_DIRECTORY,
		"runes icons_",
		icon_resources,
		"ArrayMesh"
	)

	# Only keep runes that have both mesh and icon
	for rune_name in mesh_resources:
		if icon_resources.has(rune_name):
			runes[rune_name] = RuneResources.new(
				rune_name,
				mesh_resources[rune_name],
				icon_resources[rune_name]
			)

	if runes.is_empty():
		success = false
		print("No complete rune sets (mesh + icon) found")

	return success

## Scans a directory for rune resources
## Returns true if successful, false if there was an error
func _scan_directory(directory: String, prefix: String, out_resources: Dictionary, resource_type: String) -> bool:
	var success: bool = true

	var files: PackedStringArray = ResourceLoader.list_directory(directory)
	if files:
		for file_name in files:
			if file_name.begins_with(prefix) and file_name.ends_with(".res"):
				var rune_name: String = _extract_rune_name(file_name, prefix)
				var resource_path: String = directory + file_name
				var resource: Resource = load(resource_path)
				if resource:
					out_resources[rune_name] = resource
				else:
					success = false
					print("Failed to load " + resource_type + " resource: " + resource_path)
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

## Returns the mesh resource for a given rune name
## Returns null if the rune doesn't exist
func get_rune_mesh(rune_name: String) -> ArrayMesh:
	if not runes.has(rune_name):
		print("Rune not found: " + rune_name)
		return null
	return runes[rune_name].mesh

## Returns the icon resource for a given rune name
## Returns null if the rune doesn't exist
func get_rune_icon(rune_name: String) -> ArrayMesh:
	if not runes.has(rune_name):
		print("Rune not found: " + rune_name)
		return null
	return runes[rune_name].icon

## Returns a list of all available rune names
## These runes are guaranteed to have both mesh and icon resources
func get_available_runes() -> Array[String]:
	return runes.keys()
