extends CanvasLayer

var path = ""

# func _ready():
# 	transition_to("res://Main.tscn", "Fade")

func transition_to(scene, anim):
	path = scene
	$Transition/TransitionPlayer.play(anim)
	# self.z_index = VisualServer.CANVAS_ITEM_Z_MAX


func change_scene():
	if path:
		print(get_tree().change_scene(path))


func change_color(color):
	$Transition/TransitionRect.color = color
