extends Node3D


func _on_area_3d_area_entered(area: Area3D) -> void:
	if !Global.game_started and area.is_in_group("player_hand"):
		Global.game_started = true
		Events.start_game.emit()
