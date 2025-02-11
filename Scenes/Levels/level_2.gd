class_name Level2
extends StaticBody3D

const MAGIC_BOOK = preload("res://Scenes/Game/Books/magic_book.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var fail_sound: AudioStreamPlayer3D = $FailSound
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()
	animation_player.play("appear")
	collision_shape_3d.disabled = false

	Events.level_2_completed.connect(_on_level_2_completed)
	Events.wrong_book.connect(_on_wrong_book)
	# Events.start_game.connect(_on_start_game)

	Global.level = 2
	place_magic_book()


func _on_start_game() -> void:
	place_magic_book() # Generate runes
	show()
	collision_shape_3d.disabled = false
	animation_player.play("appear")


func place_magic_book() -> void:
	var book_positions: Array[Node] = get_node("Books").get_children()
	var magic_book_pos: Marker3D = book_positions.pop_front()
	magic_book_pos.add_child(MAGIC_BOOK.instantiate())
	Events.place_on_pedistal.emit(MAGIC_BOOK.resource_path)

	for book in get_tree().get_nodes_in_group("book"):
		book.freeze = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		Events.level_3_load.emit()
		hide()


func _on_audio_stream_player_3d_finished() -> void:
	animation_player.play("fade")


func _on_level_2_completed() -> void:
	audio_stream_player_3d.play()


func _on_wrong_book() -> void:
	fail_sound.play()
