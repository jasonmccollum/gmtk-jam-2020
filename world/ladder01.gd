extends Node2D



export var move_speed = 100
export var max_y = 1600

func _process(delta):
	position.y += move_speed * delta
	
	if position.y >= max_y:
		queue_free()


func _on_Area2D_body_entered(body):
	if(body.name == "Player"):
		get_node("../Player").canClimb = true


func _on_Area2D_body_exited(body):
	if(body.name == "Player"):
		get_node("../Player").canClimb = false
