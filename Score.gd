extends RichTextLabel

var font = DynamicFont.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	font.font_data = load(globals.font_dir)
	font.size = 250
	self.set("custom_fonts/normal_font", font)
	self.append_bbcode("[center]"+str(globals.score)+"[/center]")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
