@tool
class_name GameScene
extends XRToolsSceneBase

const LEVEL_2 = preload("res://Scenes/Levels/level_2.tscn")
const LEVEL_3 = preload("res://Scenes/Levels/level_3.tscn")

@onready var level_1: Level1 = $Level1
@onready var level_2: Level2 = LEVEL_2.instantiate()
@onready var level_3: Level3 = LEVEL_3.instantiate()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.level_2_load.connect(_on_level_2_load)
	Events.level_3_load.connect(_on_level_3_load)


func _on_level_2_load() -> void:
	remove_child(level_1)
	add_child(level_2)


func _on_level_3_load() -> void:
	remove_child(level_2)
	add_child(level_3)
