extends StaticBody3D

@onready var rune_positions: Array[Node] = get_node("Runes").get_children()
"res://Scenes/Game/Runes/Pickable/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Events.start_game.connect(_on_start_game)
	generate_runes()


func _on_start_game() -> void:
	show()


func generate_runes() -> void:
	pass
