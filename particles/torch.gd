extends Sprite

export var min_size = 2
export var max_size = 4
export var max_delta = 2

func _process(delta):
	$Light2D.scale = Vector2.ONE * clamp(rand_range(min_size, max_size), $Light2D.scale.x - max_delta*delta, $Light2D.scale.x + max_delta*delta)
