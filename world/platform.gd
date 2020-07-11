extends KinematicBody2D

export var move_speed = 100
export var max_y = 1600

var velocity = Vector2(0, 0)

func _process(delta):
	velocity = Vector2(0, move_speed)
	velocity = move_and_slide(velocity)
	
	if position.y >= max_y:
		queue_free()
