extends RichTextLabel

var font = DynamicFont.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	font.font_data = load("res://fonts/Cloude_Regular_Bold_1.02.ttf")
	font.size = 250
	self.set("custom_fonts/normal_font", font)


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
#	pass
