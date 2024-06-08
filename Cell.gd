extends Area2D

var row_index = 0
var col_index = 0
var cell_color = Color("B3DFA0")
var stylebox = StyleBoxFlat.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	stylebox.bg_color = cell_color
	stylebox.border_color = Color.BLACK
	$ColorRect.add_theme_stylebox_override("panel", stylebox)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	stylebox.bg_color = cell_color.darkened(0.2)
	



func _on_mouse_exited():
	stylebox.bg_color = cell_color

# Function to update the visual color of the cell
func update_color(new_color):
	cell_color = new_color
	stylebox.bg_color = new_color
	
func get_color():
	return cell_color

func update_top_border(border_width):
	stylebox.border_width_top = border_width

func update_right_border(border_width):
	stylebox.border_width_right = border_width

func update_bottom_border(border_width):
	stylebox.border_width_bottom = border_width

func update_left_border(border_width):
	stylebox.border_width_left = border_width
