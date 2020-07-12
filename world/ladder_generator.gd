extends Node2D

export var generation_distance = 300
export var generation_y = -600
export var min_ladders_per_row = 3
export var max_ladders_per_row = 5
export var y_variation_per_row = 250
export var x_buffer = 100
export var max_y = 1600

export (Array, PackedScene) var ladder_bases = []

var ladders = []
var is_generating_ladders = false
var last_row = null
var move_speed = 0

onready var max_generation_x = get_viewport_rect().size.x
onready var row_x_step = max_generation_x / max_ladders_per_row

func _ready():
	yield(get_tree().create_timer(.1), "timeout")
	generate_row()
	is_generating_ladders = true

func set_move_speed(amount):
	move_speed = amount

func _process(delta):
	if is_generating_ladders:
		if average_distance_to_last_row() >= generation_distance:
			generate_row()

func move_ladders(delta):
	for ladder in ladders:
		ladder.position.y += move_speed * delta
		
		if ladder.position.y >= max_y:
			ladders.remove(ladders.find(ladder))
			ladder.queue_free()

func average_distance_to_last_row():
	# Returns the average y of the row
	var sum = 0
	for ladder in last_row:
		sum += ladder.position.y

	return sum / last_row.size()

func generate_row():
	last_row = []
	
	# Boolean array of ladder positions to generate
	# There is always a ladder on the left, center, and right of the screen
	var rows_to_create = [1]
	for i in range(max_ladders_per_row - 2):
		if i == round(max_ladders_per_row / 2):
			rows_to_create.append(1)
		else:
			rows_to_create.append(round(randf()))
	rows_to_create.push_back(1)
	
	for i in range(rows_to_create.size()):
		if rows_to_create[i] == 0:
			continue
		
		var x = rand_range(i * row_x_step + x_buffer, (i + 1) * row_x_step - x_buffer)
		var y = generation_y + rand_range(-y_variation_per_row, y_variation_per_row)

		var ladder = generate_ladder(x, y)
		ladders.append(ladder)
		last_row.append(ladder)

func generate_ladder(x, y):
	var index = randi() % ladder_bases.size()
	var ladder = ladder_bases[index].instance()
	ladder.position = Vector2(x, y)
	add_child(ladder)

	return ladder
