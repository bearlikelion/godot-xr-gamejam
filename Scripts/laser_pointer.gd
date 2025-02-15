@tool
extends XRToolsFunctionPointer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_laser = LaserShow.HIDE
	Events.start_game.connect(_on_start_game)
	Events.level_5_load.connect(_on_level_5_load)
	Events.level_6_load.connect(_on_level_6_load)

	if Global.level > 0:
		_on_start_game()


func _on_start_game() -> void:
	show_laser = LaserShow.SHOW


func _on_level_5_load() -> void:
	show_laser = LaserShow.HIDE


func _on_level_6_load() -> void:
	show_laser = LaserShow.SHOW
