extends ColorRect

var path = ""


func transition_to(scene, anim):
	path = scene
	$AnimationPlayer.play(anim)


func change_scene():
	if path:
		get_tree().change_scene(path)


func change_color(color):
	self.color = color
