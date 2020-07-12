extends KinematicBody2D


export (float) var speed = 300
export (float) var gravity = 50
export (float) var fall_animation_min_velocity = 10

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
var is_jumping = false

# Ladders
var canClimb = false
var onLadder = false
var overlapping_ladders = []

var velocity = Vector2()
var on_floor = true
# Helper info for animation states
var horizontal_input = false

func get_input():
	horizontal_input = false
	var move_vector = Vector2(0, 0)

	if Input.is_action_pressed('right'):
		get_node( "AnimatedSprite" ).set_flip_h( false )
		move_vector.x = 1
		horizontal_input = true
	elif Input.is_action_pressed('left'):
		move_vector.x = -1
		get_node( "AnimatedSprite" ).set_flip_h( true )
		horizontal_input = true

	if Input.is_action_pressed('up') and canClimb:
		move_vector.y -= 1
	elif Input.is_action_pressed('down') and canClimb:
		move_vector.y += 1

	# Let the player climb normally if on a ladder
	if canClimb and !is_jumping:
		velocity = move_vector.normalized() * speed
	else:
		velocity.x = move_vector.x * speed
		
	if Input.is_action_pressed("jump") and move_vector.y == 0 and (on_floor or canClimb) and !is_jumping:
		velocity.y = -1200
		is_jumping = true
#		if(is_on_floor() or onLadder):
#			jumpMeter = maxJump
#		if(jumpMeter > 0):
#			$AnimatedSprite.play("Jump")
#			jumpMeter -= delta*100
#			velocity.y += -1000
#			jump_released = true

func update_animations():
	if(canClimb):
		if velocity.length() == 0:
			$AnimatedSprite.stop()
		else:
			$AnimatedSprite.play("Climb")
	else:
		if velocity.length() == 0:
			$AnimatedSprite.play("default")
		if velocity.x != 0 and on_floor and horizontal_input:
			$AnimatedSprite.play("Run")
		elif velocity.y > fall_animation_min_velocity:
			$AnimatedSprite.play("JumpDown")
		elif velocity.y < 0:
			$AnimatedSprite.play("Jump")
		else:
			$AnimatedSprite.play("default")

func update_state():
	on_floor = is_on_floor()
	canClimb = overlapping_ladders.size() > 0
	if on_floor:
		is_jumping = false

func _physics_process(delta):
	update_state()

	velocity.y += gravity
	get_input()

	velocity = move_and_slide(velocity, Vector2.UP)
	
	update_animations()


func _on_ladder_area_area_entered(area):
	if area.name == 'climb_area':
		overlapping_ladders.append(area)


func _on_ladder_area_area_exited(area):
	if area.name == 'climb_area':
		overlapping_ladders.remove(overlapping_ladders.find(area))
