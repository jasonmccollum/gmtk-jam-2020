extends StaticBody2D

export var move_speed = 100
export var max_y = 1600

func _process(delta):
	position.y += move_speed * delta
	
	if position.y >= max_y:
		queue_free()
