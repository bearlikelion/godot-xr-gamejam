extends Label3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Events.start_game.connect(_on_start_game)
	Events.podium_rose.connect(_on_podium_rose)
	Events.new_rune_to_match.connect(_on_new_rune_to_match)


func _on_start_game() -> void:
	# queue_free()
	text = "Find the matching rune"


func _on_podium_rose() -> void:
	show()


func _on_new_rune_to_match(icon_scene: String) -> void:
	hide()
