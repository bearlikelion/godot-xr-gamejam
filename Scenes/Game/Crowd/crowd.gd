class_name Crowd
extends Node3D

@export var walking: bool = false

@onready var player_body: XRToolsPlayerBody = get_tree().get_first_node_in_group("player_body")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if not walking:
		look_at(player_body.position)
