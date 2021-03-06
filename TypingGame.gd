extends Control

export var words_alpha = 0.5
export var correct_char_color = Color("#ffffff")  # FIXME: not readable
export var incorrect_char_color = Color("#f90000")
export var untyped_color = Color("#808080")  # FIXME: not readable
export var transition_anim = "Fade"
export var num_chars = 200

var font = DynamicFont.new()
var chars_to_type = ""
var chars_typed = 0
var chars_correct = 0
var time_elapsed = 0
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
	$Words.set("custom_fonts/normal_font", font)
	# $Words.set("custom_colors/font_color", Color(0.5, 0.5, 0.5))
	# $Words.modulate.a = words_alpha
	$TypedWords.set("custom_fonts/normal_font", font)
	font.font_data = load(globals.font_dir)
	font.size = 90
	var wordfile = File.new()
	wordfile.open("res://assets/words.csv", File.READ)
	var words = wordfile.get_as_text().split("\n")

	var words_to_type = PoolStringArray()
	var rand_word_index
	var rand_word
	var total_chars = 0
	while total_chars <= num_chars+1:
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
	Transition.get_node("AmbientAudio").stream_paused = true
	if Transition.get_node("FastAudio").stream_paused:
		Transition.get_node("FastAudio").stream_paused = false
	else:
		Transition.get_node("FastAudio").play()


func rand_choice(lst):
	return lst[randi() % lst.size()]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta


func _input(event):
	if chars_typed == len(chars_to_type):
		return
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
			chars_correct += 1
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
			update_score(stepify(int(chars_correct*100.0/chars_typed) + globals.english_preparedness, 0.01))
			Transition.change_color(globals.minigame_color)
			Transition.transition_to("res://Score.tscn", transition_anim)


func colored_bbcode(text, color):
	"""Colored text, color as hex code."""
	return "[color=%s]%s[/color]" % [color, text]


func update_score(score):
	if globals.english_score[0] == null:
		assert(globals.english_score[1] == 0, "Shouldn't happen.")
		globals.minigame_score = score
		globals.english_score = [score, 1]
		return
	globals.minigame_score = score
	globals.english_score[0] = (globals.english_score[0]*globals.english_score[1]+score)/(globals.english_score[1]+1)
	globals.english_score[1] += 1
