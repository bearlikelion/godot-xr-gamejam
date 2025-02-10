extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rune_positions: Array[Node] = get_node("Runes").get_children()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Events.start_game.connect(_on_start_game)
	generate_runes()


func _on_start_game() -> void:
	show()
	animation_player.play("appear")

func generate_runes() -> void:
	pass
