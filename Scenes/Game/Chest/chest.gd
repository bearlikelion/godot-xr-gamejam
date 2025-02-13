extends StaticBody3D

@onready var animation_player: AnimationPlayer = $chest/AnimationPlayer
@onready var fail: AudioStreamPlayer3D = $Fail
@onready var unlock: AudioStreamPlayer3D = $Unlock


func _ready() -> void:
	animation_player.play("Close")


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is ChestKey:
		if body.golden_key:
			print("UNLOCK")
			unlock.play()
			animation_player.play("Open")
		else:
			print("Wrong key")
			fail.play()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Open":
		animation_player.play("hat_bob")
