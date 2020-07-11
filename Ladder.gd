extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Ladder_body_entered(body):
	if(body.name == "Player"):
		get_node("../Player").onLadder = true


func _on_Ladder_body_exited(body):
	if(body.name == "Player"):
		get_node("../Player").onLadder = false
