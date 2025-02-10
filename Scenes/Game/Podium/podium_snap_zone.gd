extends XRToolsSnapZone


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Events.start_game.connect(_on_start_game)


func _on_start_game() -> void:
	show()
