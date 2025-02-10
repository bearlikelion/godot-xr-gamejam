extends Label3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Events.start_game.connect(_on_start_game)
	Events.podium_rose.connect(_on_podium_rose)


func _on_start_game() -> void:
	queue_free()


func _on_podium_rose() -> void:
	show()
