@tool
class_name Credits
extends Control

@export_tool_button("Generate Credits") var generate_action: Callable = generate_credits

@export var scroll: bool = false
@export var scroll_speed: float = 25.0

@export_group("Formatting")
@export var h1_font_size: int = 48
@export var h2_font_size: int = 32
@export var h3_font_size: int = 24
@export var h4_font_size: int = 16

var text: String
var amount: float
var current_scroll: float = 0.0

# @onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var credits_label: RichTextLabel = %Credits
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.show_credits.connect(_on_show_credits)


func generate_credits() -> void:
	text = FileAccess.get_file_as_string("res://CREDITS.md")
	var end_of_first_line: int = text.find("\n") + 1
	text = text.right(-end_of_first_line)
	text = text.replace("\r\n", "\n")
	text = text.replace("\n\r", "\n")
	text = text.replace("\\" + "\n", "\n")
	text = _regex_replace_comments(text)
	text = _regex_replace_urls(text)
	text = _regex_replace_titles(text)
	credits_label.text = ("[center]%s[/center]") % [text]


## Match and remove lines starting with "[]:" (with any content inside the brackets)
func _regex_replace_comments(credits: String) -> String:
	var regex: RegEx = RegEx.new()
	var match_string: String = "(?:.*\\n)?\\[.*?\\]:.*(?:\\n|$)"
	regex.compile(match_string)
	return regex.sub(credits, "", true)


func _regex_replace_urls(credits: String) -> String:
	var regex: RegEx = RegEx.new()
	var match_string: String = "\\[([^\\]]*)\\]\\(([^\\)]*)\\)"
	var replace_string: String = "\n[url=$2]$1[/url]"
	regex.compile(match_string)
	return regex.sub(credits, replace_string, true)


func _regex_replace_titles(credits: String) -> String:
	var iter: int = 0
	var heading_font_sizes: Array[int] = [h1_font_size, h2_font_size, h3_font_size, h4_font_size]
	for heading_font_size in heading_font_sizes:
		iter += 1
		var regex: RegEx = RegEx.new()
		var match_string: String = "([^#]|^)#{%d}\\s([^\\n]*)" % iter
		var replace_string: String = "$1[font_size=%d]$2[/font_size]" % [heading_font_size]
		regex.compile(match_string)
		credits = regex.sub(credits, replace_string, true)
	return credits


func _on_show_credits() -> void:
	print("Scroll Credits")
	animation_player.play("scroll_credits")
