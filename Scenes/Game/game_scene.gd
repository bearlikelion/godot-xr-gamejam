@tool
class_name GameScene
extends XRToolsSceneBase

@export_enum("LEVEL_1", "LEVEL_2", "LEVEL_3", "LEVEL_4", "LEVEL_5", "LEVEL_6", "LEVEL_7") var starting_level: String

const LEVEL_1 = preload("res://Scenes/Levels/level_1.tscn")
const LEVEL_2 = preload("res://Scenes/Levels/level_2.tscn")
const LEVEL_3 = preload("res://Scenes/Levels/level_3.tscn")
const LEVEL_4 = preload("res://Scenes/Levels/level_4.tscn")
const LEVEL_5 = preload("res://Scenes/Levels/level_5.tscn")
const LEVEL_6 = preload("res://Scenes/Levels/level_6.tscn")
const LEVEL_7 = preload("res://Scenes/Levels/level_7.tscn")

@onready var level_1: Node3D = LEVEL_1.instantiate()
@onready var level_2: Node3D = LEVEL_2.instantiate()
@onready var level_3: Node3D = LEVEL_3.instantiate()
@onready var level_4: Node3D = LEVEL_4.instantiate()
@onready var level_5: Node3D = LEVEL_5.instantiate()
@onready var level_6: Node3D = LEVEL_6.instantiate()
@onready var level_7: Node3D = LEVEL_7.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		return

	match starting_level:
		"LEVEL_1":
			add_child(level_1)
		"LEVEL_2":
			Events.start_game.emit()
			add_child(level_2)
		"LEVEL_3":
			Events.start_game.emit()
			add_child(level_3)
		"LEVEL_4":
			Events.start_game.emit()
			add_child(level_4)
		"LEVEL_5":
			Events.start_game.emit()
			add_child(level_5)
		"LEVEL_6":
			Events.start_game.emit()
			add_child(level_6)
		"LEVEL_7":
			Events.start_game.emit()
			add_child(level_7)

	Events.level_2_load.connect(_on_level_2_load)
	Events.level_3_load.connect(_on_level_3_load)
	Events.level_4_load.connect(_on_level_4_load)
	Events.level_5_load.connect(_on_level_5_load)
	Events.level_6_load.connect(_on_level_6_load)
	Events.level_7_load.connect(_on_level_7_load)


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


func _on_level_6_load() -> void:
	remove_child(level_5)
	add_child(level_6)


func _on_level_7_load() -> void:
	remove_child(level_6)
	add_child(level_7)
