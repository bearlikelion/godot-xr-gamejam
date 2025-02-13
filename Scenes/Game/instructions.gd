extends Label3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Events.start_game.connect(_on_start_game)
	Events.podium_rose.connect(_on_podium_rose)
	Events.level_2_load.connect(_on_level_2_load)
	Events.level_3_load.connect(_on_level_3_load)
	Events.level_4_load.connect(_on_level_4_load)
	Events.find_tool.connect(_on_find_tool)
	Events.spawn_staff_head.connect(_on_spawn_staff_head)
	Events.staff_head_connected.connect(_on_staff_head_connected)
	Events.staff_forged.connect(_on_staff_forged)


func _on_podium_rose() -> void:
	show()
	animation_player.play("fade")


func _on_start_game() -> void:
	text = "Find the matching rune"
	animation_player.play("fade")


func _on_level_2_load() -> void:
	animation_player.play("RESET")
	text = "Find the magic book"
	animation_player.play("fade")


func _on_level_3_load() -> void:
	animation_player.play("RESET")
	text = "Find a\nsturdy crystal"
	animation_player.play("fade")


func _on_level_4_load() -> void:
	animation_player.play("RESET")
	text = "Place the crystal\non the anvil"
	animation_player.play("fade")


func _on_find_tool() -> void:
	animation_player.play("RESET")
	text = "Find the right tool\nto craft a gem"
	animation_player.play("fade")


func _on_spawn_staff_head() -> void:
	animation_player.play("RESET")
	text = "Attach the gem\nto a staff"
	animation_player.play("fade")


func _on_staff_head_connected() -> void:
	animation_player.play("RESET")
	text = "Enchant the staff\nin the flame"
	animation_player.play("fade")


func _on_staff_forged() -> void:
	animation_player.play("RESET")
	text = "Place the staff\non the podium"
	animation_player.play("fade")
