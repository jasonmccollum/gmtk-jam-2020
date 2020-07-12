extends KinematicBody2D

export (float) var speed = 300
export (float) var gravity = 50
export (float) var fall_animation_min_velocity = 10
export (float) var min_insanity = 10

#Involuntary movement Variables
var current_insanity = 0
var insanityLevel = 0
var insaneMoveCount = 0
const baseInsanityMovement = 2
var isInsane = false
var playerDead = false

#Jump Variables
export var jump_power := 1000
var jump_released = false
var jumpTimer = 0
const maxJumpTime = 0.2
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
var timer

func _ready():
	SetTimer()
	
func SetTimer():
	timer = Timer.new()
	timer.set_wait_time( 2 )
	timer.connect("timeout", self, "timeOut")
	add_child(timer) #to process
	timer.start()
	
func timeOut():
	isInsane = true
	timer.set_wait_time(randf()*5.0+1.0)
	timer.start()

func HandleInsaneMovement():
	velocity.x = randf()*2.0-1.0
	velocity.y = randf()*2.0-1.0
	velocity = velocity.normalized() * (speed) * (5)
	
	insaneMoveCount += 1
	if(insaneMoveCount >= 30):
		isInsane = false
		insaneMoveCount = 0

func update_insanity(amount):
	current_insanity = amount
	
func check_sanity(delta):
	if current_insanity > min_insanity and isInsane:
		HandleInsaneMovement()

func get_input(delta):
	horizontal_input = false
	var climb_pressed = false
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
		climb_pressed = true
	elif Input.is_action_pressed('down') and canClimb:
		move_vector.y += 1
		climb_pressed = true

	# Let the player climb normally if on a ladder
	if canClimb and (!is_jumping or climb_pressed):
		is_jumping = false
		jumpTimer = 0
		velocity = move_vector.normalized() * speed
	else:
		velocity.x = move_vector.x * speed
		
	if Input.is_action_pressed("jump") and !climb_pressed and move_vector.y == 0 and (on_floor or canClimb or is_jumping) and can_jump:
		is_jumping = true
		jump(delta)
		
	if Input.is_action_just_released("jump"):
		can_jump = false

func jump(delta):
	if (jumpTimer < maxJumpTime):
		velocity.y -= get_decay_weight(jumpTimer, maxJumpTime) * jump_power
		jumpTimer += delta

func update_animations():
	if(canClimb) and !is_jumping:
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
		can_jump = true
		jumpTimer = 0
	elif canClimb:
		can_jump = true

func kill_player():
	$AnimatedSprite.play("Death")
	playerDead = true

func _physics_process(delta):
	if(playerDead):
		return

	update_state()

	velocity.y += gravity
	get_input(delta)
	check_sanity(delta)

	velocity = move_and_slide(velocity, Vector2.UP)

	update_animations()

func _on_ladder_area_area_entered(area):
	if area.name == 'climb_area':
		overlapping_ladders.append(area)

func _on_ladder_area_area_exited(area):
	if area.name == 'climb_area':
		overlapping_ladders.remove(overlapping_ladders.find(area))

func get_decay_weight(x, a=1, b=0.99):
	return a * pow(1-b, x)
