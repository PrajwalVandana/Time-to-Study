extends CanvasItem

export var CELL_PADDING_RATIO = .125
export var RADIUS_RATIO = .05

var cell_size
var cell_padding
var radius
var base_style = StyleBoxFlat.new()
var rects = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
var font = DynamicFont.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size = get_viewport_rect().size
	cell_size = min(screen_size.x, screen_size.y) / (5 * CELL_PADDING_RATIO + 4)
	cell_padding = CELL_PADDING_RATIO * cell_size
	radius = RADIUS_RATIO * cell_size
	base_style.set_corner_radius_all(radius)
	base_style.set_bg_color(Color(0.5, 0.5, 0.5))
	font.font_data = load('res://Cloude_Regular_Bold_1.02.ttf')
	randomize()
	init_cells()
	add_new_cell()


func _draw():
	for r in range(4):
		for c in range(4):
			draw_style_box(get_style_box(rects[r][c][1]), rects[r][c][0])
			if rects[r][c][1] != null:
				var offset
				var value_str = str(rects[r][c][1])
				print(value_str)
				if len(value_str) == 1:
					offset = Vector2(cell_size * 0.25, cell_size * 0.75)
					font.size = 250
				elif len(value_str) == 2:
					offset = Vector2(cell_size * 0.15, cell_size * 0.75)
					font.size = 200
				elif len(value_str) == 3:
					offset = Vector2(cell_size * 0.05, cell_size * 0.75)
					font.size = 150
				draw_string(font, rects[r][c][0].position + offset, value_str)



# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass


func _input(event):
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
		return
	update()
	add_new_cell()


func rand_choice(lst):
	return lst[randi() % lst.size()]


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