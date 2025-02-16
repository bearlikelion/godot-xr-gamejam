extends Label3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()

	if Global.level > 0:
		match Global.level:
			1:
				_on_level_1_instructions()
			2:
				_on_level_2_load()
			3:
				_on_level_3_load()
			4:
				_on_level_4_load()
			5:
				_on_level_5_load()
			6:
				_on_level_6_load()
			7:
				_on_level_7_load()

	Events.podium_rose.connect(_on_podium_rose)
	Events.level_1_instructions.connect(_on_level_1_instructions)
	Events.level_2_load.connect(_on_level_2_load)
	Events.level_3_load.connect(_on_level_3_load)
	Events.level_4_load.connect(_on_level_4_load)
	Events.find_tool.connect(_on_find_tool)
	Events.spawn_staff_head.connect(_on_spawn_staff_head)
	Events.staff_head_connected.connect(_on_staff_head_connected)
	Events.staff_forged.connect(_on_staff_forged)
	Events.level_5_load.connect(_on_level_5_load)
	Events.failed_simon.connect(_on_failed_simon)
	Events.level_6_load.connect(_on_level_6_load)
	Events.level_7_load.connect(_on_level_7_load)
	Events.chest_opened.connect(_on_chest_opened)
	Events.repeat_instructions.connect(_on_repeat_instructions)
	Events.restart_level.connect(_on_restart_level)


func _on_podium_rose() -> void:
	if Global.level == 0:
		animation_player.play("RESET")
		text = "Touch the podium\nto begin"
		animation_player.play("fade")


func _on_level_1_instructions() -> void:
	animation_player.play("RESET")
	text = "Find the\nmatching rune"
	animation_player.play("fade")


func _on_level_2_load() -> void:
	animation_player.play("RESET")
	text = "Find the\nmagic book"
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
	text = "Use the correct tool\nto make a gem"
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


func _on_level_5_load() -> void:
	animation_player.play("RESET")
	text = "Follow the\nsequence"
	animation_player.play("fade")


func _on_failed_simon() -> void:
	animation_player.play("RESET")
	text = "Incorrect\nsequence"
	animation_player.play("fade")


func _on_level_6_load() -> void:
	animation_player.play("RESET")
	text = "Mix the potion"
	animation_player.play("fade")


func _on_level_7_load() -> void:
	animation_player.play("RESET")
	text = "Find the golden key\nto unlock the chest"
	animation_player.play("fade")


func _on_chest_opened() -> void:
	animation_player.play("RESET")
	text = "Wear the Wizard Hat"
	animation_player.play("fade")


func _on_repeat_instructions() -> void:
	animation_player.play("RESET")
	animation_player.play("fade")


func _on_restart_level() -> void:
	animation_player.play("RESET")
	if Global.level == 8:
		text = "Restarting Game"
	else:
		text = "Restarting level"

	animation_player.play("fade")
	await get_tree().create_timer(1.5).timeout
	if Global.level == 8 or Global.level == 1:
		Global.level = 0
	Events.reload_level.emit()
