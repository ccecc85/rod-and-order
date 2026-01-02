extends Node2D

@export var grid_size: int = 64	# size of each grid cell in pixels
@export var half_extent: int = 20 # 20 tiles each direction

# Draw a debug grid representing the floor
func _draw() -> void:
	var min_x := -half_extent * grid_size	# min x coordinate
	var max_x :=  half_extent * grid_size	# max x coordinate
	var min_y := -half_extent * grid_size	# min y coordinate
	var max_y :=  half_extent * grid_size	# max y coordinate

	# vertical lines
	for x in range(min_x, max_x + 1, grid_size): 
		draw_line(Vector2(x, min_y), Vector2(x, max_y), Color(0.25, 0.25, 0.25), 2.0)

	# horizontal lines
	for y in range(min_y, max_y + 1, grid_size):
		draw_line(Vector2(min_x, y), Vector2(max_x, y), Color(0.25, 0.25, 0.25), 2.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()
