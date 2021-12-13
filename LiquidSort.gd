extends Control

export var vial_color = Color(0.5, 0.5, 0.5)
export var highlight_color = Color("#eadabe")
export var col1 = Color(1, 0, 0)
export var col2 = Color(0, 0, 1)
export var col3 = Color(0, 1, 0)
export var vial_padding_bottom = 5
export var liquid_size = 96
export var transition_anim = "Fade"

var vials
var vial_rects = []
var highlighted_vial = null
var prob_randomize_vial = 0.99

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	match globals.difficulty:
		"easy":
			vials = [[col1, col1, col1], [col2, col2, col2], []]
			vial_rects = [0, 0, 0]
		"medium":
			vials = [[col1, col1, col1], [col2, col2, col2], [col3, col3, col3], []]
			vial_rects = [0, 0, 0, 0]
		"hard":
			vials = [[col1, col1, col1], [col2, col2, col2], [col3, col3, col3]]
			vial_rects = [0, 0, 0]
	randomize_vials()
	Transition.get_node("AmbientAudio").stream_paused = true
	if Transition.get_node("FastAudio").stream_paused:
		Transition.get_node("FastAudio").stream_paused = false
	else:
		Transition.get_node("FastAudio").play()
	$Countdown.start()

func _draw():
	var screen_size = get_viewport_rect().size
	var vial_rect
	var this_vial_color
	var bubbles
	for i in range(len(vials)):
		bubbles = get_node("Bubbles"+str(i+1))
		if i == highlighted_vial:
			this_vial_color = highlight_color
		else:
			this_vial_color = vial_color
		vial_rect = Rect2(
			Vector2(
				screen_size.x*(2*i+1)/(2*len(vials)+1)+screen_size.x/(12*len(vials)+6),
				screen_size.y/6
			),
			Vector2(50, 400)
		)
		vial_rects[i] = vial_rect
		draw_rect(
			vial_rect,
			this_vial_color
		)
		if len(vials[i]):
			bubbles.visible = true
			bubbles.position = Vector2(vial_rect.position.x+vial_rect.size.x/2, vial_rect.position.y+vial_rect.size.y-vial_padding_bottom-12)
			bubbles.process_material.emission_sphere_radius = 2
			bubbles.lifetime = pow(1.25*liquid_size*len(vials[i])/bubbles.process_material.gravity.y, 0.5)*0.5
		else:
			bubbles.visible = false
		for j in range(len(vials[i])):
			draw_rect(Rect2(
				Vector2(
					screen_size.x*(2*i+1)/(2*len(vials)+1)+screen_size.x/(9*len(vials)+4.5),
					screen_size.y/6+4*100-(j+1)*liquid_size-vial_padding_bottom
				),
				Vector2(35, liquid_size)
			), vials[i][j])
	if len(vials) == 3:
		$Bubbles4.emitting = false
		$Bubbles4.visible = false


func pour(v1, v2):
	"""Pour vial v1 into vial v2."""
	if len(v1) == 0 or len(v2) == 4:
		return
	v2.append(v1.pop_back())


func randomize_vials():
	while true:
		if weighted_choice([[false, 1-prob_randomize_vial], [true, prob_randomize_vial]]):
			var v1 = randi() % vials.size()
			var v2 = randi() % vials.size()
			while v1 == v2:
				v2 = randi() % vials.size()
			pour(vials[v1], vials[v2])
		else:
			break


func weighted_choice(choices):
	"""
	Return a random element from a non-empty sequence choices.
	The probability of each element is given by its second entry in the sequence.
	"""
	var r = randf()
	var cumulative_weight = 0
	for choice in choices:
		if cumulative_weight + choice[1] >= r:
			return choice[0]
		cumulative_weight += choice[1]

	assert(false, "Shouldn't get here.")


func rand_choice(lst):
	return lst[randi() % lst.size()]


func _input(event):
	$Countdown.paused = true
	if event is InputEventMouseButton and event.pressed:
		if highlighted_vial != null:  # a vial was selected
			for i in range(len(vial_rects)):
				if vial_rects[i].has_point(event.position):
					pour(vials[highlighted_vial], vials[i])
			highlighted_vial = null
		else:  # no vial was selected
			for i in range(len(vial_rects)):
				if vial_rects[i].has_point(event.position):
					highlighted_vial = i
		update()
		for vial in vials:
			if len(vial) != 0 and len(vial) != 3:
				$Countdown.paused = false
				return
			for i in range(1, len(vial)):
				if vial[i] != vial[i-1]:
					$Countdown.paused = false
					return
		update_score(get_score())
		Transition.change_color(globals.minigame_color)
		Transition.transition_to("res://Score.tscn", transition_anim)
	else:
		$Countdown.paused = false


func get_score():
	return stepify(floor($Countdown.time_left*100.0/$Countdown.wait_time) + globals.science_preparedness, 0.01)


func _on_Countdown_timeout():
	update_score(get_score())
	Transition.change_color(globals.minigame_color)
	Transition.transition_to("res://Score.tscn", transition_anim)


func update_score(score):
	if globals.science_score[0] == null:
		assert(globals.science_score[1] == 0, "Shouldn't happen.")
		globals.minigame_score = score
		globals.science_score = [score, 1]
		return
	globals.minigame_score = score
	globals.science_score[0] = (globals.science_score[0]*globals.science_score[1]+score)/(globals.science_score[1]+1)
	globals.science_score[1] += 1
