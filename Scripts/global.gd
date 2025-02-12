extends Node

var testing: bool = false # DO NOT SHIP WITH TRUE
var game_started: bool = false
var level: int = 1
var rune_to_match: String = ""


func _ready() -> void:
	Events.place_on_pedistal.connect(_on_place_on_pedistal)
	Events.podium_snapped.connect(_on_podium_snapped)


func _on_place_on_pedistal(icon_scene: String) -> void:
	rune_to_match = icon_scene.get_file().replace("icon_", "")\
	.replace("rune_", "")\
	.replace(".tscn", "")

	print("Global rune to match: %s" % rune_to_match)


func _on_podium_snapped(object_name: String) -> void:
	if object_name == rune_to_match and level == 1:
		print("Level 1 Completed")
		Events.level_1_completed.emit()

	if level == 2:
		if object_name == "magic_book":
			print("Level 2 Completed")
			Events.level_2_completed.emit()
		else:
			Events.wrong_book.emit()

	if level == 3:
		if object_name == "magic_crystal":
			print("Level 3 Completed")
			Events.level_3_completed.emit()
		else:
			Events.wrong_crystal.emit()
