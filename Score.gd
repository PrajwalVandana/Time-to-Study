extends Node

var text_font = DynamicFont.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Background.color = globals.minigame_color
	var shared_font_data = load(globals.font_dir)
	text_font.font_data = shared_font_data
	text_font.size = 250
	$Score.set("custom_fonts/normal_font", text_font)
	$ScoreLabel.set("custom_fonts/normal_font", text_font)
	$Score.append_bbcode("[center]"+str(globals.minigame_score)+"[/center]")
	$Button.set("custom_colors/font_color_hover", $Background.color)
	globals.minigame_score = 0


func _on_Button_pressed():
	Transition.change_color(Color(0, 0, 0))
	Transition.transition_to("res://Main.tscn", "ScoreTransition")
