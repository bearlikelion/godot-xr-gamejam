@tool
class_name GameScene
extends XRToolsSceneBase

@export_enum("LEVEL_1", "LEVEL_2", "LEVEL_3", "LEVEL_4",\
"LEVEL_5", "LEVEL_6", "LEVEL_7", "LEVEL_8") var starting_level: String

const LEVEL_1 = preload("res://Scenes/Levels/level_1.tscn")
const LEVEL_2 = preload("res://Scenes/Levels/level_2.tscn")
const LEVEL_3 = preload("res://Scenes/Levels/level_3.tscn")
const LEVEL_4 = preload("res://Scenes/Levels/level_4.tscn")
const LEVEL_5 = preload("res://Scenes/Levels/level_5.tscn")
const LEVEL_6 = preload("res://Scenes/Levels/level_6.tscn")
const LEVEL_7 = preload("res://Scenes/Levels/level_7.tscn")
const LEVEL_8 = preload("res://Scenes/Levels/level_8.tscn")

var current_level: Node3D

@onready var base: Node3D = $Base
@onready var level_1: Node3D = LEVEL_1.instantiate()
@onready var level_2: Node3D = LEVEL_2.instantiate()
@onready var level_3: Node3D = LEVEL_3.instantiate()
@onready var level_4: Node3D = LEVEL_4.instantiate()
@onready var level_5: Node3D = LEVEL_5.instantiate()
@onready var level_6: Node3D = LEVEL_6.instantiate()
@onready var level_7: Node3D = LEVEL_7.instantiate()
@onready var level_8: Node3D = LEVEL_8.instantiate()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		return

	Events.level_2_load.connect(_on_level_2_load)
	Events.level_3_load.connect(_on_level_3_load)
	Events.level_4_load.connect(_on_level_4_load)
	Events.level_5_load.connect(_on_level_5_load)
	Events.level_6_load.connect(_on_level_6_load)
	Events.level_7_load.connect(_on_level_7_load)
	Events.level_8_load.connect(_on_level_8_load)
	Events.reload_level.connect(_on_reload_level)

	match starting_level:
		"LEVEL_1":
			add_child(level_1)
			current_level = level_1
		"LEVEL_2":
			Events.start_game.emit()
			add_child(level_2)
			current_level = level_2
		"LEVEL_3":
			Events.start_game.emit()
			add_child(level_3)
			current_level = level_3
		"LEVEL_4":
			Events.start_game.emit()
			add_child(level_4)
			current_level = level_4
		"LEVEL_5":
			Events.start_game.emit()
			add_child(level_5)
			current_level = level_5
		"LEVEL_6":
			Events.start_game.emit()
			add_child(level_6)
			current_level = level_6
		"LEVEL_7":
			Events.start_game.emit()
			add_child(level_7)
			current_level = level_7
		"LEVEL_8":
			Events.start_game.emit()
			add_child(level_8)
			current_level = level_8
			base.queue_free()


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


func _on_level_8_load() -> void:
	remove_child(level_7)
	add_child(level_8)
	if is_instance_valid(base):
		base.queue_free()


func _on_reload_level() -> void:
	match Global.level:
		1:
			level_1.queue_free()
			add_child(current_level)
		2:
			level_2.queue_free()
			add_child(current_level)
		3:
			level_3.queue_free()
			add_child(current_level)
		4:
			level_4.queue_free()
			add_child(current_level)
		5:
			level_5.queue_free()
			add_child(current_level)
		6:
			level_6.queue_free()
			add_child(current_level)
		7:
			level_7.queue_free()
			add_child(current_level)
