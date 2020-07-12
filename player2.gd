extends KinematicBody2D


export (float) var speed = 300
export (float) var gravity = 100

#Involuntary movement Variables
var insanityLevel = 0
var insaneMoveCount = 0
const baseInsanityMovement = 2
var isInsane = false
var insanity_timer

# Ladders
var canClimb = false
var onLadder = false

var velocity = Vector2()

func get_input():
	var move_vector = Vector2(0, 0)

	if Input.is_action_pressed('right'):
		get_node( "AnimatedSprite" ).set_flip_h( false )
		move_vector.x = 1
	elif Input.is_action_pressed('left'):
		move_vector.x = -1
		get_node( "AnimatedSprite" ).set_flip_h( true )

	if Input.is_action_pressed('up') and canClimb:
		move_vector.y -= 1
	if Input.is_action_pressed('down') and canClimb:
		move_vector.y += 1

	# Let the player climb normally if on a ladder
	if canClimb:
		velocity = move_vector.normalized() * speed
	else:
		velocity.x = move_vector.x * speed

func update_animations():
	if(onLadder):
		if velocity.length() == 0:
			$AnimatedSprite.stop()
		else:
			$AnimatedSprite.play("Climb")
	else:
		if velocity.length() == 0:
			$AnimatedSprite.play("default")

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity, Vector2.UP)
	
	update_animations()
