extends Node

export var words_alpha = 0.5
export var correct_char_color = Color("#ffffff")
export var incorrect_char_color = Color("#f90000")
export var untyped_color = Color("#808080")
export var transition_color = Color("#fdce00")

var font = DynamicFont.new()
var chars_to_type = ""
var chars_typed = 0
const ignored_chars = [
	KEY_SHIFT,
	KEY_MASK_CMD,
	KEY_ALT,
	KEY_META,
	KEY_CAPSLOCK,
	KEY_NUMLOCK,
	KEY_SCROLLLOCK,
	KEY_ESCAPE,
	KEY_CONTROL
]


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	font.font_data = load(globals.font_dir)
	font.size = 90
	$Words.set("custom_fonts/normal_font", font)
	# $Words.set("custom_colors/font_color", Color(0.5, 0.5, 0.5))
	# $Words.modulate.a = words_alpha
	$TypedWords.set("custom_fonts/normal_font", font)

	var wordfile = File.new()
	wordfile.open("assets/words.txt", File.READ)
	var words = wordfile.get_as_text().split("\n")

	var words_to_type = PoolStringArray()
	var rand_word_index
	var rand_word
	var total_chars = 0
	while total_chars <= 201:
		rand_word_index = randi() % len(words)
		rand_word = words[rand_word_index]
		words.remove(rand_word_index)
		words_to_type.append(rand_word)
		total_chars += len(rand_word) + 1

	# var chars_in_line = 0
	# for i in range(len(words_to_type)):
	# 	if chars_in_line > 30:
	# 		chars_in_line = 0
	# 		chars_to_type = chars_to_type.substr(0, len(chars_to_type)-1) + "\n" + words_to_type[i] + " "
	# 	else:
	# 		chars_in_line += len(words_to_type[i])+1
	# 		chars_to_type += words_to_type[i] + "-"
	chars_to_type = words_to_type.join(" ")
	for c in chars_to_type:
		$Words.bbcode_text += colored_bbcode(c, "#"+untyped_color.to_html(false))


func rand_choice(lst):
	return lst[randi() % lst.size()]


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass


func _input(event):
	if event is InputEventKey and event.pressed:
		# char format: "[color=#ffffff]a[/color]"
		if event.scancode in ignored_chars:
			return

		if event.unicode == ord(chars_to_type[chars_typed]):
			$Words.bbcode_text = (
				$Words.bbcode_text.substr(0, 24 * chars_typed + 7)
				+ "#" + correct_char_color.to_html(false)
				+ $Words.bbcode_text.substr(24 * chars_typed + 14)
			)
		else:
			if chars_to_type[chars_typed] == " ":
				$Words.bbcode_text = (
					$Words.bbcode_text.substr(0, 24 * chars_typed + 7)
					+ "#" + incorrect_char_color.to_html(false)
					+ "]_"
					+ $Words.bbcode_text.substr(24 * chars_typed + 16)
				)
			else:
				$Words.bbcode_text = (
					$Words.bbcode_text.substr(0, 24 * chars_typed + 7)
					+ "#" + incorrect_char_color.to_html(false)
					+ $Words.bbcode_text.substr(24 * chars_typed + 14)
				)
		chars_typed += 1
		if chars_typed == len(chars_to_type):
			TransitionPlayer.transition_to("res://Score.tscn")


func colored_bbcode(text, color):
	"""Colored text, color as hex code."""
	return "[color=%s]%s[/color]" % [color, text]
