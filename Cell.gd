extends Area2D

var row_index = 0
var col_index = 0
var cell_color = Color("B3DFA0")

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.color = cell_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	$ColorRect.color = $ColorRect.color.darkened(0.2)
	



func _on_mouse_exited():
	$ColorRect.color = cell_color

# Function to update the visual color of the cell
func update_color(new_color):
	cell_color = new_color
	$ColorRect.color = new_color.darkened(0)
	
