extends StaticBody3D

const RUNE_ICONS = preload("res://Resources/rune_icons.tres")
const PICKABLE_RUNES = preload("res://Resources/pickable_runes.tres")

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Events.start_game.connect(_on_start_game)
	generate_runes()


func _on_start_game() -> void:
	generate_runes() # Regenerate runes
	show()
	animation_player.play("appear")

func generate_runes() -> void:
	# Place a random rune on the podium
	var runic_icons: Array = RUNE_ICONS.duplicate().rune_icons
	runic_icons.shuffle()
	var rune_to_match: Resource = runic_icons.pop_front()
	Events.new_rune_to_match.emit(rune_to_match.resource_path)

	var pickable_runes: Array = PICKABLE_RUNES.duplicate().pickable_runes
	var rune_positions: Array[Node] = get_node("Runes").get_children()
	rune_positions.shuffle()

	for pickable_rune: Resource in pickable_runes:
		if pickable_rune.resource_path.get_file().replace("rune_", "") == \
		rune_to_match.resource_path.get_file().replace("icon_", ""):
			print("Match rune: %s" % pickable_rune.resource_path.get_file())
			var first_position: Marker3D = rune_positions.pop_front()
			var first_rune: PackedScene = load(pickable_rune.resource_path)
			first_position.add_child(first_rune.instantiate())
			pickable_runes.erase(pickable_rune) # Only one correct rune

	for rune_position: Marker3D in rune_positions:
		pickable_runes.shuffle()
		var _rune: PackedScene = load(pickable_runes.front().resource_path)
		if rune_position.get_children().size() > 0:
			for child_rune: Node3D in rune_position.get_children():
				child_rune.queue_free()

		rune_position.add_child(_rune.instantiate())
