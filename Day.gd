extends Control

export var transition_after = 4

var time_elapsed = 0
var transitioned = false
var game_over = true


# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property(
		$Restart,
		"modulate",
		Color(1, 1, 1, 0),
		Color(1, 1, 1, 1),
		2,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	if globals.day == 51:
		if globals.english_score[0] <= 50 or globals.history_score[0] <= 50 or globals.math_score[0] <= 50 or globals.science_score[0] <= 50:
			$Text.append_bbcode("\n\n[center][color=#ff0000]You failed high school.[/color][/center]")
		elif globals.happiness == 0:
			$Text.append_bbcode("\n\n[center][color=#ff0000]You dropped out to focus on your mental health.[/color][/center]")
		else:
			$Text.append_bbcode("\n\n[center][color=#ffd700]You graduated![/color][/center]")
	elif globals.happiness == 0:
		$Text.append_bbcode("\n\n[center][color=#ff0000]You dropped out to focus on your mental health.[/color][/center]")
	else:
		$Restart.visible = false
		$Text.append_bbcode("\n\n[center][color=#ffffff]Day %d[/color][/center]" % globals.day)
		game_over = false
	$Tween.start()
	$TextAnimator.play("Text Fade")


func _process(delta):
	time_elapsed += delta
	if not game_over and time_elapsed > transition_after and not transitioned:
			Transition.change_color(Color(0, 0, 0))
			Transition.transition_to(globals.minigame, "Fade")
			transitioned = true


func _on_Restart_pressed():
	print(Directory.new().remove("save.json"))
	globals.happiness = 20
	globals.english_preparedness = 0
	globals.english_score = [null, 0]  # in the form [average, number of assignments]
	globals.math_preparedness = 0
	globals.math_score = [null, 0]
	globals.science_preparedness = 0
	globals.science_score = [null, 0]
	globals.history_preparedness = 0
	globals.history_score = [null, 0]
	globals.day = 0
	globals.savefile_read = false
	print(get_tree().change_scene("res://Main.tscn"))
