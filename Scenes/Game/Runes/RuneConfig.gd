@tool
extends Node

# Directories containing the assets
const MESH_DIRECTORY := "res://Assets/Models/Runes/Rocks/Mesh/"
const ICON_DIRECTORY := "res://Assets/Models/Runes/Static/Mesh/"

# Dictionaries mapping rune names to their resource paths.
var rune_meshes := {}
var rune_icons := {}

func _ready() -> void:
	# Populate the maps when this script is initialized.
	scan_rune_meshes()
	scan_rune_icons()

func scan_rune_meshes() -> void:
	var dir: PackedStringArray = ResourceLoader.list_directory(MESH_DIRECTORY)
	if dir:
		for file_name in dir:
				# Expecting file name of format: runes_NAME.res
				if file_name.begins_with("runes_") and file_name.ends_with(".res"):
					# Extract the rune name.
					var prefix_length = "runes_".length()
					var ext_length = ".res".length()
					var rune_name = file_name.substr(prefix_length, file_name.length() - prefix_length - ext_length)
					rune_meshes[rune_name] = MESH_DIRECTORY + file_name
	else:
		print("Failed to open directory: ", MESH_DIRECTORY)

func scan_rune_icons() -> void:
	var dir: DirAccess = DirAccess.open(ICON_DIRECTORY)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and not file_name.begins_with("."):
				# Expecting file name of format: runes icons_Algiz.res
				if file_name.begins_with("runes icons_") and file_name.ends_with(".res"):
					var prefix_length = "runes icons_".length()
					var ext_length = ".res".length()
					var rune_name = file_name.substr(prefix_length, file_name.length() - prefix_length - ext_length)
					rune_icons[rune_name] = ICON_DIRECTORY + file_name
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Failed to open directory: ", ICON_DIRECTORY)

# Helper function to retrieve a rune mesh's resource path using its name.
func get_rune_mesh(rune_name:String) -> String:
	if rune_meshes.has(rune_name):
		return rune_meshes[rune_name]
	else:
		print("Rune mesh not found for: ", rune_name)
		return ""

# Helper function to retrieve a rune icon's resource path using its name.
func get_rune_icon(rune_name:String) -> String:
	if rune_icons.has(rune_name):
		return rune_icons[rune_name]
	else:
		print("Rune icon not found for: ", rune_name)
		return ""
