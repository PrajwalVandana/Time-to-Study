extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	globals.day += 1
	var savefile = File.new()
	if not savefile.file_exists("save.json") or globals.savefile_read:
		savefile.open("save.json", File.WRITE)
		savefile.store_line(to_json({
			happiness = globals.happiness,
			english_preparedness = globals.english_preparedness,
			math_preparedness = globals.math_preparedness,
			science_preparedness = globals.science_preparedness,
			history_preparedness = globals.history_preparedness,
			day = globals.day,
			english_score = globals.english_score,
			math_score = globals.math_score,
			science_score = globals.science_score,
			history_score = globals.history_score
		}))
		globals.savefile_read = true
	else:
		savefile.open("save.json", File.READ)
		var savedata = parse_json(savefile.get_line())
		globals.happiness = savedata.happiness
		globals.english_preparedness = savedata.english_preparedness
		globals.english_score = savedata.english_score
		globals.math_preparedness = savedata.math_preparedness
		globals.math_score = savedata.math_score
		globals.science_preparedness = savedata.science_preparedness
		globals.science_score = savedata.science_score
		globals.history_preparedness = savedata.history_preparedness
		globals.history_score = savedata.history_score
		globals.day = savedata.day

		globals.savefile_read = true

	randomize()
	var minigame = rand_choice(
		["res://2048.tscn", "res://TypingGame.tscn", "res://LiquidSort.tscn"]
	)
	globals.minigame = minigame
	globals.difficulty = rand_choice(["easy", "medium", "hard"])
	match minigame:
		"res://2048.tscn":
			globals.minigame_color = globals.math_color
		"res://TypingGame.tscn":
			globals.minigame_color = globals.english_color
		"res://LiquidSort.tscn":
			globals.minigame_color = globals.science_color
	print(get_tree().change_scene("res://Day.tscn"))


func rand_choice(lst):
	return lst[randi() % lst.size()]


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
#	pass
