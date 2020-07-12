extends KinematicBody2D


export (float) var speed = 300
export (float) var gravity = 50

#Involuntary movement Variables
var insanityLevel = 0
var insaneMoveCount = 0
const baseInsanityMovement = 2
var isInsane = false
var insanity_timer

#Jump Variables
export var jump_power := 15000.0
var jump_released = false
var jumpMeter = 0
const maxJump = 50
var can_jump = false

# Ladders
var canClimb = false
var onLadder = false

var velocity = Vector2()
var on_floor = true

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
	elif Input.is_action_pressed('down') and canClimb:
		move_vector.y += 1

	# Let the player climb normally if on a ladder
	if canClimb:
		velocity = move_vector.normalized() * speed
	else:
		velocity.x = move_vector.x * speed
		
	if Input.is_action_pressed("jump") and move_vector.y == 0 and (on_floor or canClimb):
		velocity.y = -1200
#		if(is_on_floor() or onLadder):
#			jumpMeter = maxJump
#		if(jumpMeter > 0):
#			$AnimatedSprite.play("Jump")
#			jumpMeter -= delta*100
#			velocity.y += -1000
#			jump_released = true

func update_animations():
	if(onLadder):
		if velocity.length() == 0:
			$AnimatedSprite.stop()
		else:
			$AnimatedSprite.play("Climb")
	else:
		if velocity.length() == 0:
			$AnimatedSprite.play("default")
		if velocity.x != 0 and on_floor:
			$AnimatedSprite.play("Run")
		elif velocity.y > 0:
			$AnimatedSprite.play("JumpDown")
		elif velocity.y < 0:
			$AnimatedSprite.play("Jump")
		else:
			$AnimatedSprite.play("default")

func _physics_process(delta):
	velocity.y += gravity
	on_floor = is_on_floor()
	get_input()

	velocity = move_and_slide(velocity, Vector2.UP)
	
	update_animations()
