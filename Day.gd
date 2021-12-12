extends Control

export var transition_after = 4

var time_elapsed = 0
var transitioned = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$Text.append_bbcode("[center][color=#ffffff]Day %d[/color][/center]" % globals.day)
	$TextAnimator.play("Text Fade")


func _process(delta):
	time_elapsed += delta
	if time_elapsed > transition_after and not transitioned:
		Transition.change_color(Color(0, 0, 0))
		Transition.transition_to(globals.minigame, "ScoreTransition")
		transitioned = true

