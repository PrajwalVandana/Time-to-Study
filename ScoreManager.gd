extends Node

var text_font = DynamicFont.new()
var button_font = DynamicFont.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	globals.game_won = null
	var shared_font_data = load(globals.font_dir)
	text_font.font_data = shared_font_data
	text_font.size = 250
	button_font.font_data = shared_font_data
	button_font.size = 100
	$Score.set("custom_fonts/normal_font", text_font)
	$ScoreLabel.set("custom_fonts/normal_font", text_font)
	$Score.append_bbcode("[center]"+str(globals.score)+"[/center]")
	$Button.set("custom_fonts/font", button_font)


func _on_Button_pressed():
	print(get_tree().change_scene("res://Main.tscn"))
