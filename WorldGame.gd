extends Control

export var turn_radians = 0.05
export var speed = 200
export var transition_anim = "Fade"

var cities = []
var chosen_city
var player_dir = Vector2(0, -1)
var location_picked = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var cities_file = File.new()
	cities_file.open("res://assets/world_cities.csv", File.READ)
	var population_min = 0
	match globals.difficulty:
		"easy":
			population_min = 5_000_000
		"medium":
			population_min = 2_000_000
		"hard":
			population_min = 1_000_000
	var finished_reading = false
	while not finished_reading:
		var city = cities_file.get_line().split(",", true)
		if len(city) == 1:
			finished_reading = true
		else:
			if int(city[9]) > population_min:
				cities.append(
					[
						city[1],
						Vector2(
							$Map.rect_size.x * (180 + string_to_float(city[3])) / 360.0,
							$Map.rect_size.y * (90 - string_to_float(city[2])) / 180.0
						)
					]
				)

	chosen_city = rand_choice(cities)
	$Label.append_bbcode(chosen_city[0].lstrip('"').rstrip('"'))
	$Plane/Camera.current = true


func rand_choice(lst):
	return lst[randi() % lst.size()]


func string_to_float(s):
	if "." in s:
		var a = s.split(".", true)
		return float(int(a[1]) + int(a[0]) * pow(10, a[1].length())) / pow(10, a[1].length())
	else:
		return float(s)


func _process(delta):
	$Label.rect_position = $Plane.position + Vector2(200, -200)
	# update velocity
	if Input.is_action_pressed("ui_right"):
		player_dir = player_dir.rotated(turn_radians)
		$Plane.rotation += turn_radians
	if Input.is_action_pressed("ui_left"):
		player_dir = player_dir.rotated(-turn_radians)
		$Plane.rotation += -turn_radians
	if Input.is_key_pressed(KEY_SPACE):
		print($Plane.position - chosen_city[1])
		update_score(
			(
				stepify(100 * exp(-0.002 * ($Plane.position - chosen_city[1]).length()), 0.01)
				+ globals.history_preparedness
			)
		)
		$Camera.position = $Plane.position + $Plane/Camera.position
		# $Tween.interpolate_property(
		# 	$Camera,
		# 	"zoom",
		# 	Vector2(1, 1),
		# 	Vector2(
		# 		$Map.rect_size.x / get_viewport_rect().size.x,
		# 		$Map.rect_size.y / get_viewport_rect().size.y
		# 	),
		# 	1,
		# 	Tween.TRANS_SINE,
		# 	Tween.EASE_IN_OUT
		# )
		$Tween.interpolate_property(
			$Camera,
			"position",
			$Camera.position,
			chosen_city[1],
			1,
			Tween.TRANS_SINE,
			Tween.EASE_IN_OUT
		)
		$Camera.current = true
		location_picked = true
		update()
		$Label.visible = false
		$Tween.start()
	if not location_picked:
		$Plane.position += player_dir * delta * speed
		$Plane.position.x = clamp($Plane.position.x, 0, $Map.rect_size.x)
		$Plane.position.y = clamp($Plane.position.y, 0, $Map.rect_size.y)


func _draw():
	if location_picked:
		draw_circle(chosen_city[1], 10, Color(1, 0, 0, 1))


func update_score(score):
	if globals.history_score[0] == null:
		assert(globals.history_score[1] == 0, "Shouldn't happen.")
		globals.minigame_score = score
		globals.history_score = [score, 1]
		return
	globals.minigame_score = score
	globals.history_score[0] = (
		(globals.history_score[0] * globals.history_score[1] + score)
		/ (globals.history_score[1] + 1)
	)
	globals.history_score[1] += 1


func _on_Tween_tween_all_completed():
	Transition.change_color(globals.minigame_color)
	Transition.transition_to("res://Score.tscn", transition_anim)
