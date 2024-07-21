extends Control
const orange = Color("#ffc992")
const gray = Color("#dfdfdf")
const blue = Color("#96beff")
const yellow = Color("#e6f388")
const green = Color("#b3dfa0")
const brown = Color("#b9b29e")
const purple = Color("b59ddb")
const red = Color("ff2b2b")
const pink = Color("#dfa0bf")
const aqua = Color("#a3d2d8")

var selected_color_rect = null
var selected_color = null;

var row = 11
var column = 11
var Cell_scene = preload("res://Cell.tscn")
var cell_size = 64
var cells = []
var cell_colors = []
var changed_cells = []
var isMouseDown = false

var default_border_width = 2
var no_border_width = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	init_grids()
	createColorRectangles()


func createColorRectangles():
	var colors = [orange, gray, blue, yellow, green, brown, purple, red, pink, aqua]
	for color in colors:
		var color_rectangle = Panel.new()
		color_rectangle.custom_minimum_size = Vector2(64,64)
		
		var stylebox = StyleBoxFlat.new()
		stylebox.bg_color = color
		color_rectangle.add_theme_stylebox_override("panel", stylebox)
		
		$ColorsContainer.add_child(color_rectangle)
		color_rectangle.connect("gui_input", Callable(self, "_on_ColorRect_gui_input").bind(color_rectangle))
		highlight_color_rect($ColorsContainer.get_child(0))
		selected_color = colors[0]

func _on_ColorRect_gui_input(event, color_rectangle):
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		highlight_color_rect(color_rectangle)
		selected_color = color_rectangle.get_theme_stylebox("panel").bg_color
		

func highlight_color_rect(color_rect):
	if selected_color_rect != null:
		# Reset the previously selected rectangle's border
		var prev_stylebox = selected_color_rect.get_theme_stylebox("panel")
		prev_stylebox.set_border_width_all(0)
		selected_color_rect.add_theme_stylebox_override("panel", prev_stylebox)
	
	# Highlight the clicked rectangle
	var stylebox = color_rect.get_theme_stylebox("panel")
	stylebox.set_border_width_all(3)  # Change border width to highlight
	stylebox.border_color = Color.BLACK  # Change border color if needed
	color_rect.add_theme_stylebox_override("panel", stylebox)
	
	selected_color_rect = color_rect

func init_grids():
	for i in range(row):
		cell_colors.append([])
		for j in range(column):
			var cell = Cell_scene.instantiate()
			cell.row_index = i
			cell.col_index = j
			cell.position = Vector2(cell_size * j, cell_size * i) + Vector2(0, 0)
			cells.append(cell)
			cell_colors[i].append(green)
			add_child(cell)
			cell.connect("input_event", Callable(self, "_on_cell_input_event").bind(cell))

func _on_cell_input_event(viewport, event, shape_idx, cell):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			isMouseDown = event.pressed
			if not isMouseDown:
				if cell not in changed_cells:
					change_cell_color(cell)
					changed_cells.append(cell)
				changed_cells = []
				
	elif event is InputEventMouseMotion and isMouseDown:
		if cell not in changed_cells:
			change_cell_color(cell)
			changed_cells.append(cell)

func change_cell_color(cell):
	cell.update_color(selected_color)
	cell_colors[cell.row_index][cell.col_index] = selected_color
	update_borders()
	
func update_borders():
	for i in range(len(cells)):
		var cell = cells[i]
		
		var top_cell = null
		var right_cell = null
		var bottom_cell = null
		var left_cell = null
		
		#### OUTLINE BORDERS #####
		if i % column == 0: #Left border
			cell.update_left_border(default_border_width)
		else:
			left_cell = cells[i-1]
		if i < column: #Top border
			cell.update_top_border(default_border_width)
		else:
			top_cell = cells[i-column]
		if i % column == column-1: #Right border
			cell.update_right_border(default_border_width)
		else:
			right_cell = cells[i+1]
		if i >= (row-1)*column: #Bottom border
			cell.update_bottom_border(default_border_width)
		else:
			bottom_cell = cells[i+column]
		################################
		
		var cell_color = cell.get_color()
		
		
		if top_cell:
			if cell_color != top_cell.get_color():
				cell.update_top_border(default_border_width)
			else:
				cell.update_top_border(no_border_width)
		
		if right_cell:
			if cell_color != right_cell.get_color():
				cell.update_right_border(default_border_width)
			else:
				cell.update_right_border(no_border_width)
		if bottom_cell:
			if cell_color != bottom_cell.get_color():
				cell.update_bottom_border(default_border_width)
			else:
				cell.update_bottom_border(no_border_width)
		if left_cell:
			if cell_color != left_cell.get_color():
				cell.update_left_border(default_border_width)
			else:
				cell.update_left_border(no_border_width)

func _input(event):
	#For fixing the holding down problem when releasing the mouse button outside of the cells
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			isMouseDown = false
