@tool
class_name GameScene
extends XRToolsSceneBase

const LEVEL_2 = preload("res://Scenes/Levels/level_2.tscn")

@onready var level_1: Level1 = $Level1
@onready var level_2: Level2 = LEVEL_2.instantiate()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.level_2_load.connect(_on_level_2_load)


func _on_level_2_load() -> void:
	remove_child(level_1)
	add_child(level_2)
