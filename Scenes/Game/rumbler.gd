@tool
extends XRToolsRumbler

@export_enum("LEFT", "RIGHT") var hand: String

@onready var _controller: XRController3D = XRHelpers.get_xr_controller(self)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.rumble.connect(_on_rumble_event)


func _on_rumble_event(hand_name: String, body_name: String) -> void:
	print("Rumble Hand: %s" % hand_name)
	print("Hand: %s" % hand)
	if hand_name == hand:
		print("RUMBLE ME")
		XRToolsRumbleManager.add(hand_name + "_" + body_name, event, [_controller])
