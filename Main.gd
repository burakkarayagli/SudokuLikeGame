extends Node

var row = 9
var column = 9
var size = 64
var Cell_scene = preload("res://Cell.tscn")
var click_timer: Timer = null
var cells = []
var isMouseDown = false
var changedCells = []

#Feature for changing the same cell types while holding
var initialCellState = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	init_grids()
	
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
			cell.position = Vector2(size * j, size * i) + Vector2(offset_x, offset_y)
			cells.append(cell)
			add_child(cell)
			cell.connect("input_event", Callable(self, "_on_cell_input_event").bind(cell))

func _on_cell_input_event(viewport, event, shape_idx, cell):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			isMouseDown = event.pressed
			if not isMouseDown:
				if cell not in changedCells:
					changeCellText(cell)
					showCellLabel(cell)
					changedCells.append(cell)
				changedCells = []
			else:
				initialCellState = cell.get_node("Label").text
				
	elif event is InputEventMouseMotion and isMouseDown:
		if cell not in changedCells:
			changeCellTextWhileHolding(cell)
			showCellLabel(cell)
			changedCells.append(cell)

func changeCellText(cell):
	var label = cell.get_node("Label")
	if label.text == "":
		label.text = "x"
	elif label.text == "x":
		label.text = "Q"
	elif label.text == "Q":
		label.text = "" 

func changeCellTextWhileHolding(cell):
	var label = cell.get_node("Label")
	if label.text == initialCellState:
		if label.text == "":
			label.text = "x"
		elif label.text == "x":
			label.text = ""

func showCellLabel(cell):
	$CellClickLabel.text = str("Entered cell at row:", cell.row_index, "column:", cell.col_index)
	$CellClickLabel.show()
	if click_timer == null:
		click_timer = Timer.new()
		click_timer.set_autostart(false)
		click_timer.set_wait_time(1)
		add_child(click_timer)
		click_timer.connect("timeout", _on_click_timer_timeout)
		click_timer.start()
	else:
		click_timer.start(1)

func _on_click_timer_timeout():
	$CellClickLabel.hide()  # Hide the label when the timer expires
	click_timer.stop()


func _process(delta):
	if click_timer != null:
		$Label.text = str(click_timer.get_time_left())

func _on_ResetButton_pressed():
	for cell in cells:
		cell.get_node("Label").text = ""

func _input(event):
	#For fixing the holding down problem when releasing the mouse button outside of the cells
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			isMouseDown = false
