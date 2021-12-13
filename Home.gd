extends Control

export var button_expand_duration = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	$English.set("custom_styles/hover", get_hover_style(globals.english_color))
	$History.set("custom_styles/hover", get_hover_style(globals.history_color))
	$Math.set("custom_styles/hover", get_hover_style(globals.math_color))
	$Science.set("custom_styles/hover", get_hover_style(globals.science_color))
	$Relax.set("custom_styles/hover", get_hover_style(globals.relax_color))

	$English.set("custom_styles/pressed", get_hover_style(globals.english_color))
	$History.set("custom_styles/pressed", get_hover_style(globals.history_color))
	$Math.set("custom_styles/pressed", get_hover_style(globals.math_color))
	$Science.set("custom_styles/pressed", get_hover_style(globals.science_color))
	$Relax.set("custom_styles/pressed", get_hover_style(globals.relax_color))

	$English/Label.text = '%s, %s/20' % [get_score_text(globals.english_score[0]), globals.english_preparedness]
	$History/Label.text += '%s, %s/20' % [get_score_text(globals.history_score[0]), globals.history_preparedness]
	$Math/Label.text = '%s, %s/20' % [get_score_text(globals.math_score[0]), globals.math_preparedness]
	$Science/Label.text = '%s, %s/20' % [get_score_text(globals.science_score[0]), globals.science_preparedness]
	$Relax/Label.text = '%s' % globals.happiness

	$ContinueButton.disabled = true
	$ContinueButton.modulate = Color(1, 1, 1, 0)

	Transition.get_node("FastAudio").stream_paused = true
	Transition.get_node("AmbientAudio").stream_paused = false


func _process(_delta):
	var anim_bg_size = $AnimBackground.get_sprite_frames().get_frame("default", 0).get_size()
	$AnimBackground.scale = get_viewport_rect().size / anim_bg_size


func get_hover_style(highlight_color):
	var res = StyleBoxFlat.new()
	res.bg_color = highlight_color
	res.set_border_width_all(2)
	res.border_color = Color(1, 1, 1)
	res.set_corner_radius_all(5)
	return res

func _on_ContinueButton_pressed():
	Transition.transition_to("res://Main.tscn", "Fade")

func fade_text_in():
	$Tween.interpolate_property(
		$Label,
		"modulate",
		Color(1, 1, 1, 0),
		Color(1, 1, 1, 1),
		1,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT,
		2
	)
	$Tween.interpolate_property(
		$ContinueButton,
		"modulate",
		Color(1, 1, 1, 0),
		Color(1, 1, 1, 1),
		1,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT,
		3.2
	)
	$ContinueButton.disabled = false


func update_preparedness(subject):
	var add_english = -(randi() % 5 + 1)
	var add_math = -(randi() % 5 + 1)
	var add_history = -(randi() % 5 + 1)
	var add_science = -(randi() % 5 + 1)
	var add_happiness = -(randi() % 5 + 1)
	match subject:
		"English":
			add_english *= -1
		"Math":
			add_math *= -1
		"History":
			add_history *= -1
		"Science":
			add_science *= -1
		"Relax":
			add_happiness *= -1

	var prev_english = globals.english_preparedness
	globals.english_preparedness = max(min(globals.english_preparedness + add_english, 20), 0)
	add_english = globals.english_preparedness - prev_english

	var prev_math = globals.math_preparedness
	globals.math_preparedness = max(min(globals.math_preparedness + add_math, 20), 0)
	add_math = globals.math_preparedness - prev_math

	var prev_history = globals.history_preparedness
	globals.history_preparedness = max(min(globals.history_preparedness + add_history, 20), 0)
	add_history = globals.history_preparedness - prev_history

	var prev_science = globals.science_preparedness
	globals.science_preparedness = max(min(globals.science_preparedness + add_science, 20), 0)
	add_science = globals.science_preparedness - prev_science

	var prev_happiness = globals.happiness
	globals.happiness = max(min(globals.happiness + add_happiness, 20), 0)
	add_happiness = globals.happiness - prev_happiness

	return [add_english, add_history, add_math, add_science, add_happiness]


func _on_Relax_pressed():
	animate_button($Relax)
	$Label.text = (
		"""English       %d
History       %d
Math           %d
Science      %d
Happiness   +%d
"""
		% update_preparedness("Relax")
	)
	fade_text_in()


func _on_Science_pressed():
	animate_button($Science)
	$Label.text = (
		"""English       %d
History       %d
Math           %d
Science      +%d
Happiness   %d
"""
		% update_preparedness("Science")
	)
	fade_text_in()


func _on_Math_pressed():
	animate_button($Math)
	$Label.text = (
		"""English       %d
History       %d
Math           +%d
Science      %d
Happiness   %d
"""
		% update_preparedness("Math")
	)
	fade_text_in()


func _on_History_pressed():
	animate_button($History)
	$Label.text = (
		"""English       %d
History       +%d
Math           %d
Science      %d
Happiness   %d
"""
		% update_preparedness("History")
	)
	fade_text_in()


func _on_English_pressed():
	animate_button($English)
	$Label.text = (
		"""English       +%d
History       %d
Math           %d
Science      %d
Happiness   %d
"""
		% update_preparedness("English")
	)
	fade_text_in()


func _on_Tween_tween_completed(obj: Object, _key: NodePath):
	if obj is Button and obj != $ContinueButton:
		$Background.color = obj.get("custom_styles/hover").bg_color
		obj.visible = false


func animate_button(button):
	$Tween.interpolate_property(
		button,
		"rect_position",
		button.rect_position,
		Vector2(0, 0),
		button_expand_duration,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	$Tween.interpolate_property(
		button,
		"rect_size",
		button.rect_size,
		get_viewport_rect().size,
		button_expand_duration,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	$Tween.interpolate_property(
		button,
		"custom_colors/font_color_hover",
		Color(1, 1, 1),
		Color(1, 1, 1, 0),
		button_expand_duration,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	$Tween.interpolate_property(
		button,
		"custom_colors/font_color_pressed",
		Color(1, 1, 1),
		Color(1, 1, 1, 0),
		button_expand_duration,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	$Tween.interpolate_property(
		button.get_node('Label'),
		"modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		button_expand_duration,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	$Tween.start()
	for node in [$English, $Math, $History, $Science, $Relax]:
		if node != button:
			node.queue_free()


func get_score_text(score):
	return str(stepify(score, 0.001))+'%' if score != null else "N/A"
