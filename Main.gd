extends Node2D

var day = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	# var savefile = File.new()
	# savefile.open("save.json", File.WRITE)
	# savefile.write('{"day"":0, "happiness":}')

	randomize()
	var minigame = rand_choice(
		["res://2048.tscn", "res://TypingGame.tscn", "res://LiquidSort.tscn"]
	)
	globals.minigame = minigame
	match minigame:
		"res://2048.tscn":
			globals.minigame_color = Color("#0070ff")
		"res://TypingGame.tscn":
			globals.minigame_color = Color("#fdce00")
		"res://LiquidSort.tscn":
			globals.minigame_color = Color("#25ff27")
	print(get_tree().change_scene(minigame))


func rand_choice(lst):
	return lst[randi() % lst.size()]

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
#	pass
