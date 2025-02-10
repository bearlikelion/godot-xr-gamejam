extends Node


var game_started: bool = false
var level: int = 1
var rune_to_match: String = ""


func _ready() -> void:
	Events.new_rune_to_match.connect(_on_new_rune_to_match)
	Events.rune_snapped.connect(_on_rune_snapped)


func _on_new_rune_to_match(icon_scene: String) -> void:
	rune_to_match = icon_scene.get_file().replace("icon_", "")\
	.replace("rune_", "")\
	.replace(".tscn", "")

	print("Global rune to match: %s" % rune_to_match)


func _on_rune_snapped(rune_name: String) -> void:
	if rune_name == rune_to_match and level == 1:
		print("Level 1 complete")
		Events.level_1_completed.emit()
