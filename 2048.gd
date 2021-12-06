extends CanvasItem

export var CELL_PADDING_RATIO = .125
export var RADIUS_RATIO = .05
export var highlight_color = Color("#8cff8c")

var cell_size
var cell_padding
var radius
var base_style = StyleBoxFlat.new()
var rects = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
var font1 = DynamicFont.new()
var font2 = DynamicFont.new()
var font3 = DynamicFont.new()
var new_cell = null
var outline_style = StyleBoxFlat.new()
var ending_cell = null


# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size = get_viewport_rect().size
	cell_size = min(screen_size.x, screen_size.y) / (5 * CELL_PADDING_RATIO + 4)
	cell_padding = CELL_PADDING_RATIO * cell_size
	radius = RADIUS_RATIO * cell_size
	base_style.set_corner_radius_all(radius)
	base_style.set_bg_color(Color(0.5, 0.5, 0.5))
	outline_style.set_corner_radius_all(radius)
	outline_style.set_bg_color(highlight_color)

	var shared_font_data = load('res://fonts/Cloude_Regular_Bold_1.02.ttf')
	font1.font_data = shared_font_data
	font1.size = 250
	font2.font_data = shared_font_data
	font2.size = 200
	font3.font_data = shared_font_data
	font3.size = 150

	match globals.difficulty:
		'easy':
			ending_cell = 64
		'medium':
			ending_cell = 128
		'hard':
			ending_cell = 256

	randomize()
	init_cells()
	add_new_cell()
	$Countdown.start()


func _draw():
	var highlight = false
	for r in range(4):
		for c in range(4):
			if rects[r][c] == new_cell:
				# var highlighted_style = get_style_box(rects[r][c][1])
				# highlighted_style.set_bg_color(highlighted_style.get_bg_color().linear_interpolate(highlight_color, 0.4))
				# draw_style_box(highlighted_style, rects[r][c][0])
				# new_cell = null
				# highlight = true

				var outline_rect = rects[r][c][0]
				outline_rect.position -= Vector2(cell_padding*0.25, cell_padding*0.25)
				outline_rect.end += Vector2(cell_padding*0.5, cell_padding*0.5)
				draw_style_box(outline_style, outline_rect)
				draw_style_box(get_style_box(rects[r][c][1]), rects[r][c][0])
			else:
				draw_style_box(get_style_box(rects[r][c][1]), rects[r][c][0])
			if rects[r][c][1] != null:
				var offset
				var value_str = str(rects[r][c][1])
				var font
				if len(value_str) == 1:
					font = font1
					offset = Vector2(cell_size * 0.25, cell_size * 0.75)
				elif len(value_str) == 2:
					font = font2
					offset = Vector2(cell_size * 0.12, cell_size * 0.72)
				elif len(value_str) == 3:
					font = font3
					offset = Vector2(cell_size * 0.06, cell_size * 0.65)
				if highlight:
					draw_string(font, rects[r][c][0].position + offset, value_str)
					highlight = false
				else:
					draw_string(font, rects[r][c][0].position + offset, value_str)



# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass


func _input(event):
	$Countdown.paused = true
	print($Countdown.time_left)
	var rects_copy = rects.duplicate(true)
	if event.is_action_pressed('ui_left'):
		for r in range(4):
			var lst = []
			for cell in rects[r]:
				if cell[1] != null:
					lst.append(cell[1])
			for _i in range(4-len(lst)):
				lst.append(null)
			for c in range(4):
				rects[r][c][1] = lst[c]
			for c in range(3):
				if rects[r][c][1] == rects[r][c+1][1] and rects[r][c][1] != null:
					rects[r][c][1] *= 2
					for i in range(c+2, 4):
						rects[r][i-1][1] = rects[r][i][1]
					rects[r][3][1] = null
	elif event.is_action_pressed('ui_right'):
		for r in range(4):
			var lst = []
			for cell in rects[r]:
				if cell[1] != null:
					lst.append(cell[1])
			for _i in range(4-len(lst)):
				lst.insert(0, null)
			for c in range(4):
				rects[r][c][1] = lst[c]
			for c in range(3, 0, -1):
				if rects[r][c][1] == rects[r][c-1][1] and rects[r][c][1] != null:
					rects[r][c][1] *= 2
					for i in range(c-2, -1, -1):
						rects[r][i+1][1] = rects[r][i][1]
					rects[r][0][1] = null
	elif event.is_action_pressed('ui_up'):
		for c in range(4):
			var lst = []
			for r in range(4):
				if rects[r][c][1] != null:
					lst.append(rects[r][c][1])
			for _i in range(4-len(lst)):
				lst.append(null)
			for r in range(4):
				rects[r][c][1] = lst[r]
			for r in range(3):
				if rects[r][c][1] == rects[r+1][c][1] and rects[r][c][1] != null:
					rects[r][c][1] *= 2
					for i in range(r+2, 4):
						rects[i-1][c][1] = rects[i][c][1]
					rects[3][c][1] = null
	elif event.is_action_pressed('ui_down'):
		for c in range(4):
			var lst = []
			for r in range(4):
				if rects[r][c][1] != null:
					lst.append(rects[r][c][1])
			for _i in range(4-len(lst)):
				lst.insert(0, null)
			for r in range(4):
				rects[r][c][1] = lst[r]
			for r in range(3, 0, -1):
				if rects[r][c][1] == rects[r-1][c][1] and rects[r][c][1] != null:
					rects[r][c][1] *= 2
					for i in range(r-2, -1, -1):
						rects[i+1][c][1] = rects[i][c][1]
					rects[0][c][1] = null
	else:
		$Countdown.paused = false
		return
	if rects_copy != rects:
		add_new_cell()
		update()
		for r in range(4):
			for c in range(4):
				if rects[r][c][1] == ending_cell:
					globals.game_won = true
					globals.score = 100
					print(get_tree().change_scene("res://Score.tscn"))
					return

		for r in range(4):
			for c in range(4):
				if rects[r][c][1] == null:
					$Countdown.paused = false
					return
				for vec in neighbor_positions(4, r, c):
					if rects[r][c][1] == rects[vec.x][vec.y][1]:
						$Countdown.paused = false
						return

		globals.game_won = false
		globals.score = get_score()
		print(get_tree().change_scene("res://Score.tscn"))


func rand_choice(lst):
	return lst[randi() % lst.size()]


func neighbor_positions(size, r, c, diagonals=false):
	var res = []
	for i in range(-1, 2):
		for j in range(-1, 2):
			if (diagonals or not(i and j)) and (r+i in range(size)) and (c+j in range(size)) and (i or j):
				res.append(Vector2(r+i, c+j))

	return res

func blank_cells():
	var blank_cells = []
	for r in range(4):
		for c in range(4):
			if rects[r][c][1] == null:
				blank_cells.append([r, c])
	return blank_cells


func add_new_cell():
	var cell_indices = rand_choice(blank_cells())
	var cell = rects[cell_indices[0]][cell_indices[1]]
	cell[1] = rand_choice([2, 4])
	new_cell = cell

	update()


func init_cells():
	var rect
	for r in range(4):
		for c in range(4):
			rect = Rect2(
				Vector2(
					c * cell_size + (c+1) * cell_padding,
					r * cell_size + (r+1) * cell_padding
				),
				Vector2(cell_size, cell_size)
			)
			rects[r][c] = [rect, null]


func get_style_box(value):
	var colored_style = base_style.duplicate()
	if value == 2:
		colored_style.set_bg_color(Color("#e9ddd1"))
	elif value == 4:
		colored_style.set_bg_color(Color("#eadabe"))
	elif value == 8:
		colored_style.set_bg_color(Color("#eea367"))
	elif value == 16:
		colored_style.set_bg_color(Color("#f28350"))
	elif value == 32:
		colored_style.set_bg_color(Color("#f2664d"))
	elif value == 64:
		colored_style.set_bg_color(Color("#f2472e"))
	elif value == 128:
		colored_style.set_bg_color(Color("#e8c760"))
	return colored_style


func get_score():
	var max_cell = 0
	for r in range(4):
		for c in range(4):
			if rects[r][c][1] != null:
				max_cell = max(rects[r][c][1], max_cell)
	return max_cell*100/ending_cell


func _on_Countdown_timeout():
	globals.score = get_score()
	globals.game_won = false
	print(get_tree().change_scene("res://Score.tscn"))
