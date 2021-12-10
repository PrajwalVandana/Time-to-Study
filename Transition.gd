extends Node2D

var path = ""


func transition_to(scene, anim):  # FIXME: transition is rendered behind the scene
	path = scene
	$TransitionPlayer.play(anim)
	self.z_index = VisualServer.CANVAS_ITEM_Z_MAX


func change_scene():
	if path:
		print(get_tree().change_scene(path))


func change_color(color):
	$TransitionRect.color = color
