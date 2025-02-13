@tool
class_name GameScene
extends XRToolsSceneBase

@export_enum("LEVEL_1", "LEVEL_2", "LEVEL_3", "LEVEL_4", "LEVEL_5") var starting_level: String

const LEVEL_1 = preload("res://Scenes/Levels/level_1.tscn")
const LEVEL_2 = preload("res://Scenes/Levels/level_2.tscn")
const LEVEL_3 = preload("res://Scenes/Levels/level_3.tscn")
const LEVEL_4 = preload("res://Scenes/Levels/level_4.tscn")
const LEVEL_5 = preload("res://Scenes/Levels/level_5.tscn")

@onready var level_1: Node3D = LEVEL_1.instantiate()
@onready var level_2: Node3D = LEVEL_2.instantiate()
@onready var level_3: Node3D = LEVEL_3.instantiate()
@onready var level_4: Node3D = LEVEL_4.instantiate()
@onready var level_5: Node3D = LEVEL_5.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match starting_level:
		"LEVEL_1":
			add_child(level_1)
		"LEVEL_2":
			Global.game_started = true
			add_child(level_2)
		"LEVEL_3":
			Global.game_started = true
			add_child(level_3)
		"LEVEL_4":
			Global.game_started = true
			add_child(level_4)
		"LEVEL_5":
			Global.game_started = true
			add_child(level_5)

	Events.level_2_load.connect(_on_level_2_load)
	Events.level_3_load.connect(_on_level_3_load)
	Events.level_4_load.connect(_on_level_4_load)
	Events.level_5_load.connect(_on_level_5_load)


func _on_level_2_load() -> void:
	remove_child(level_1)
	add_child(level_2)


func _on_level_3_load() -> void:
	remove_child(level_2)
	add_child(level_3)


func _on_level_4_load() -> void:
	remove_child(level_3)
	add_child(level_4)


func _on_level_5_load() -> void:
	remove_child(level_4)
	add_child(level_5)
