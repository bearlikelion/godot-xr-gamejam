class_name Level2
extends StaticBody3D

const MAGIC_BOOK = preload("res://Scenes/Game/Books/magic_book.tscn")
const MAGIC_BOOK_STATIC = preload("res://Scenes/Game/Books/magic_book_static.tscn")

var magic_book: MagicBook = MAGIC_BOOK.instantiate()

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var fail_sound: AudioStreamPlayer3D = $FailSound
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()
	Global.level = 2
	place_magic_book()
	animation_player.play("appear")

	Events.level_2_completed.connect(_on_level_2_completed)
	Events.wrong_book.connect(_on_wrong_book)


func place_magic_book() -> void:
	var book_positions: Array[Node] = get_node("Books").get_children()
	if not Global.testing:
		book_positions.shuffle()

	var magic_book_pos: Marker3D = book_positions.pop_front()
	magic_book_pos.add_child(magic_book)
	Events.place_on_pedistal.emit(MAGIC_BOOK_STATIC.resource_path)

	for book in get_tree().get_nodes_in_group("book"):
		book.freeze = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		Events.level_3_load.emit()
		hide()


func _on_audio_stream_player_3d_finished() -> void:
	magic_book.queue_free()
	animation_player.play("fade")


func _on_level_2_completed() -> void:
	audio_stream_player_3d.play()


func _on_wrong_book() -> void:
	fail_sound.play()
