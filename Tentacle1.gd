extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(delta):
	var velocity = Vector2()
	velocity.x = 0
	velocity.y = -1
	velocity = velocity.normalized() * 10
	velocity = move_and_slide(velocity)
	
	var collision = move_and_collide(velocity * delta)
	
	if collision and collision.collider.name == "Player":
		print("I collided with ", collision.collider.name)
