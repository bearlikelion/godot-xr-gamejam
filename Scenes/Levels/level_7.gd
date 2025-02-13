class_name Level7
extends Node3D

const GOLD_KEY = preload("res://Scenes/Game/Chest/gold_key.tscn")
const RUSTY_KEY = preload("res://Scenes/Game/Chest/rusty_key.tscn")

@onready var keys: Node = $Level7/Keys

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	place_keys()


func place_keys() -> void:
	var keys_placed = 0
	var key_positions: Array[Node] = keys.get_children()

	if not Global.testing:
		key_positions.shuffle()

	for _key_pos: Marker3D in key_positions:
		if keys_placed == 0:
			_key_pos.add_child(GOLD_KEY.instantiate())
		else:
			_key_pos.add_child(RUSTY_KEY.instantiate())
