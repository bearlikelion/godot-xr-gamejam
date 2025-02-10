@tool
extends XRToolsFunctionPointer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_laser = LaserShow.HIDE
	Events.start_game.connect(_on_start_game)


func _on_start_game() -> void:
	show_laser = LaserShow.SHOW
