extends Node2D

export var generation_distance = 500
export var generation_y = -400
export var min_platforms_per_row = 3
export var max_platforms_per_row = 6
export var y_variation_per_row = 250
export var x_buffer = 100

export (PackedScene) var platform_base = null

var is_generating_platforms = true
var last_row = null

onready var max_generation_x = get_viewport_rect().size.x
onready var row_x_step = max_generation_x / max_platforms_per_row

func _ready():
	generate_row()

func _process(delta):
	if is_generating_platforms:
		if average_distance_to_last_row() >= generation_distance:
			generate_row()

func average_distance_to_last_row():
	# Returns the average y of the row
	var sum = 0
	for platform in last_row:
		sum += platform.position.y

	return sum / last_row.size()

func generate_row():
	last_row = []
	
	# Boolean array of platform positions to generate
	# There is always a platform on the left, center, and right of the screen
	var rows_to_create = [1]
	for i in range(max_platforms_per_row - 2):
		if i == round(max_platforms_per_row / 2):
			rows_to_create.append(1)
		else:
			rows_to_create.append(round(randf()))
	rows_to_create.push_back(1)
	
	for i in range(rows_to_create.size()):
		if rows_to_create[i] == 0:
			continue
		
		var x = rand_range(i * row_x_step + x_buffer, (i + 1) * row_x_step - x_buffer)
		var y = generation_y + rand_range(-y_variation_per_row, y_variation_per_row)

		last_row.append(generate_platform(x, y))

func generate_platform(x, y):
	var platform = platform_base.instance()
	platform.position = Vector2(x, y)
	add_child(platform)

	return platform
