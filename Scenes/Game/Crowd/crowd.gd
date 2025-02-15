class_name Crowd
extends Node3D

var animation_speed: float = randf_range(0.7, 1.3)

@onready var player_body: XRToolsPlayerBody = get_tree().get_first_node_in_group("player_body")
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	animation_speed = snappedf(animation_speed, 0.1)
	if animation_player:
		animation_player.speed_scale = animation_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	look_at(player_body.global_position)
	rotate_object_local(Vector3.UP, PI)
