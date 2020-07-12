extends Node2D

export var max_charge = 100
export var use_rate = 50
export var charge_rate = 50

onready var current_charge = max_charge

var is_mouse_down = false

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			is_mouse_down = true
			visible = true
		else:
			is_mouse_down = false
			visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var root = get_tree().get_root().get_node("world")
	var blah = get_global_mouse_position()
	rotation = blah.angle_to_point(global_position)
	
	if is_mouse_down:
		current_charge -= use_rate * delta
	else:
		current_charge = clamp(current_charge + charge_rate * delta, 0, max_charge)
	
	if current_charge < 0:
		visible = false
