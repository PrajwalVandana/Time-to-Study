extends Control

export var button_expand_duration = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	$English.set("custom_styles/hover", get_hover_style(globals.english_color))
	$Math.set("custom_styles/hover", get_hover_style(globals.math_color))
	$History.set("custom_styles/hover", get_hover_style(globals.history_color))
	$Science.set("custom_styles/hover", get_hover_style(globals.science_color))
	$Relax.set("custom_styles/hover", get_hover_style(globals.relax_color))
	$English.set("custom_styles/pressed", get_hover_style(globals.english_color))
	$Math.set("custom_styles/pressed", get_hover_style(globals.math_color))
	$History.set("custom_styles/pressed", get_hover_style(globals.history_color))
	$Science.set("custom_styles/pressed", get_hover_style(globals.science_color))
	$Relax.set("custom_styles/pressed", get_hover_style(globals.relax_color))


func get_hover_style(highlight_color):
	var res = StyleBoxFlat.new()
	res.bg_color = highlight_color
	res.set_border_width_all(2)
	res.border_color = Color(1, 1, 1)
	res.set_corner_radius_all(5)
	return res


func _on_Relax_pressed():
	animate_button($Relax)


func _on_Science_pressed():
	animate_button($Science)

func _on_Math_pressed():
	animate_button($Math)


func _on_History_pressed():
	animate_button($History)


func _on_English_pressed():
	animate_button($English)


func _on_Tween_tween_completed(button: Object, _key: NodePath):
	$Background.color = button.get("custom_styles/hover").bg_color
	button.visible = false


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
	$Tween.start()
	for node in [$English, $Math, $History, $Science, $Relax]:
		if node != button:
			node.queue_free()
