extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var root = get_tree().get_root().get_node("world")
	var blah = get_global_mouse_position()
	rotation = blah.angle_to_point(global_position)
	
	#var mouseAngleX = direction.x / (absX + absY)
	#var mouseAngleY = direction.y / (absX + absY)
