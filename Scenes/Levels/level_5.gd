extends Node3D

const TIMEOUT = 2.0
const BUTTON_PANEL = preload("res://Scenes/Game/Buttons/button_panel.tscn")

var lights: Array[String] = ["Red", "Green", "Yellow", "Blue"]
var sequence: Array[String]
var player_input: Array[String]
var sequence_index: int = 0
var is_player_turn: bool = false
var input_delay: Timer = Timer.new()
var accept_input: bool = true

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $Level5/AudioStreamPlayer3D
@onready var animation_player: AnimationPlayer = $Level5/AnimationPlayer
@onready var fail_sound: AudioStreamPlayer3D = $Level5/FailSound

@onready var simon_red: AudioStreamPlayer3D = %SimonRed
@onready var simon_green: AudioStreamPlayer3D = %SimonGreen
@onready var simon_yellow: AudioStreamPlayer3D = %SimonYellow
@onready var simon_blue: AudioStreamPlayer3D = %SimonBlue


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.level = 5
	input_delay.wait_time = 0.5
	input_delay.timeout.connect(_on_input_delay_timeout)
	add_child(input_delay)
	animation_player.play("appear")

	Events.button_pushed.connect(_on_button_pushed)
	Events.place_on_pedistal.emit(BUTTON_PANEL.resource_path)


func start_simon() -> void:
	await get_tree().create_timer(3.0).timeout
	sequence.clear()
	player_input.clear()
	sequence_index = 0
	add_to_sequence()


func add_to_sequence() -> void:
	if sequence_index >= lights.size():
		print("PLAYER WINS SIMON")
		Events.level_5_completed.emit()
		audio_stream_player_3d.play()
		animation_player.play("fade")
	else:
		sequence.append(lights[randi() % lights.size()])
		play_sequence()


func play_sequence() -> void:
	is_player_turn = false
	sequence_index = 0
	print("Play Sequence: %s" % [sequence])
	for color in sequence:
		show_light(color)
		await get_tree().create_timer(2.1).timeout
	is_player_turn = true


func show_light(button_to_press: String) -> void:
	match button_to_press:
		"Red":
			animation_player.play("red")
			simon_red.play()
		"Green":
			animation_player.play("green")
			simon_green.play()
		"Yellow":
			animation_player.play("yellow")
			simon_yellow.play()
		"Blue":
			animation_player.play("blue")
			simon_blue.play()


func check_player_input(color: String) -> void:
	if not is_player_turn or not accept_input:
		return

	accept_input = false
	input_delay.start()
	player_input.append(color)

	if player_input[sequence_index] != sequence[sequence_index]:
		fail_sound.play()
		await get_tree().create_timer(3.0).timeout
		start_simon()
		return

	sequence_index += 1
	if sequence_index >= sequence.size():
		is_player_turn = false
		await get_tree().create_timer(3.0).timeout
		player_input.clear()
		add_to_sequence()


func _on_button_pushed(button_color: String) -> void:
	check_player_input(button_color)

	match button_color:
		"Red":
			animation_player.play("red")
			simon_red.play()
		"Green":
			animation_player.play("green")
			simon_green.play()
		"Yellow":
			animation_player.play("yellow")
			simon_yellow.play()
		"Blue":
			animation_player.play("blue")
			simon_blue.play()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "appear":
		start_simon()

	if anim_name == "fade":
		Events.level_6_load.emit()


func _on_input_delay_timeout() -> void:
	accept_input = true
	input_delay.stop()
