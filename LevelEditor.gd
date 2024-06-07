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

var row = 9
var column = 9
var cell_size = 64
var Cell_scene = preload("res://Cell.tscn")
var cells = []

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

func _on_ColorRect_gui_input(event, color_rectangle):
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		highlight_color_rect(color_rectangle)

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
	var offset_x = 0
	var offset_y = 0
	for i in range(row):
		offset_x = 0
		offset_y += 2
		for j in range(column):
			offset_x += 2
			var cell = Cell_scene.instantiate()
			cell.row_index = i
			cell.col_index = j
			cell.position = Vector2(cell_size * j, cell_size * i) + Vector2(offset_x, offset_y)
			cells.append(cell)
			add_child(cell)
			cell.connect("input_event", Callable(self, "_on_cell_input_event").bind(cell))
