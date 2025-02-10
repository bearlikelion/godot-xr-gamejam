extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if !Global.game_started and body.is_in_group("player_hand"):
		Events.start_game.emit()
