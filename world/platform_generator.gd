extends Node2D

export var generation_distance = 300
export var generation_y = -400
export var min_platforms_per_row = 3
export var max_platforms_per_row = 5
export var y_variation_per_row = 300
export var x_buffer = 100
export var max_y = 1600

export (Array, PackedScene) var platform_bases = []

var platforms = []
var is_generating_platforms = false
var last_row = null
var move_speed = 100

onready var max_generation_x = get_viewport_rect().size.x
onready var row_x_step = max_generation_x / max_platforms_per_row

func _ready():
	for child in get_children():
		platforms.append(child)
	yield(get_tree().create_timer(.1), "timeout")
	generate_row()
	is_generating_platforms = true
	
func set_move_speed(amount):
	move_speed = amount

func _process(delta):
	if is_generating_platforms:
		if average_distance_to_last_row() >= generation_distance:
			generate_row()

func move_platforms(delta):
	for platform in platforms:
		platform.position.y += move_speed * delta
		
		if platform.position.y >= max_y:
			platforms.remove(platforms.find(platform))
			platform.queue_free()

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

		var platform = generate_platform(x, y)
		platforms.append(platform)
		last_row.append(platform)

func generate_platform(x, y):
	var index = randi() % platform_bases.size()
	var platform = platform_bases[index].instance()
	platform.position = Vector2(x, y)
	add_child(platform)

	return platform
