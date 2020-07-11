extends KinematicBody2D

export (int) var speed = 300

#Involuntary movement Variables
var insanityLevel = 0
var insaneMoveCount = 0
const baseInsanityMovement = 2
var isInsane = false

#Jump Variables
export var fall_gravity_scale := 200.0
export var low_jump_gravity_scale := 100.0
export var jump_power := 15000.0
var jump_released = false

var onLadder = false


#Physics
var velocity = Vector2()
var earth_gravity = 70.807 # m/s^2
export var gravity_scale := 100.0
var on_floor = false
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	position =Vector2(get_viewport().size.x/2, get_viewport().size.y/2)
	SetTimer()
	pass
	
func SetTimer():
	timer = Timer.new()
	timer.set_wait_time( 2 )
	timer.connect("timeout", self, "timeOut")
	add_child(timer) #to process
	timer.start()
	
func timeOut():
	timer.set_wait_time(randf()*5.0+1.0)
	timer.start()
	
	#test code
	if(insanityLevel < 6):
		insanityLevel += 1
		
	isInsane = true

func get_input():
	if (isInsane and insanityLevel > 0):
		HandleInsaneMovement()
#	else:
#		HandleNormalMovement()



func HandleInsaneMovement():
	velocity.x = randf()*2.0-1.0
	velocity.y = randf()*2.0-1.0
	velocity = velocity.normalized() * (speed) * (insanityLevel)
	
	insaneMoveCount+=1
	if(insaneMoveCount >= 30):
		isInsane = false
		insaneMoveCount = 0
		

func _physics_process(delta):
	
	velocity = Vector2()
	
	#General Velocity
	velocity = velocity.normalized() * speed
	
	#Move Left and Right
	if Input.is_action_pressed('right'):
		get_node( "AnimatedSprite" ).set_flip_h( false )
		velocity.x += 1
		if on_floor == false:
			$AnimatedSprite.play("Jump")
		else:
			$AnimatedSprite.play("Run")
	if Input.is_action_pressed('left'):
		velocity.x -= 1
		get_node( "AnimatedSprite" ).set_flip_h( true )
		if on_floor == false:
			$AnimatedSprite.play("Jump")
		else:
			$AnimatedSprite.play("Run")
			
	if Input.is_action_pressed('up') and onLadder:
		velocity.y -= 1
		#get_node( "AnimatedSprite" ).set_flip_h( true )
	if Input.is_action_pressed('down') and onLadder:
		velocity.y += 1
		#get_node( "AnimatedSprite" ).set_flip_h( true )


	#back to idle animation if right and left arrows are released
	if  Input.is_action_just_released('right'):

			$AnimatedSprite.play("default")
	
	if  Input.is_action_just_released('left'):
		$AnimatedSprite.play("default")
		
		
	#Handle Jump
	if Input.is_action_just_released("ui_accept"):
		$AnimatedSprite.play("Jump")
		jump_released = true
		


	#General Velocity
	velocity = velocity.normalized() * speed
	
	
	#Applying gravity to player
	if(!onLadder):
		velocity += Vector2.DOWN * earth_gravity * gravity_scale * delta

	#Jump Physics
	if velocity.y > 0: #Player is falling
		#Falling action is faster than jumping action | Like in mario
		#On falling we apply a second gravity to the player
		#We apply ((gravity_scale + fall_gravity_scale) * earth_gravity) gravity on the player
		velocity += Vector2.DOWN * earth_gravity * fall_gravity_scale * delta 
		

	elif velocity.y < 0 && jump_released: #Player is jumping 
		#Jump Height depends on how long you will hold key
		#If we release the jump before reaching the max height 
		#We apply ((gravity_scale + low_jump_gravity_scale) * earth_gravity) gravity on the player
		#It result on a lower jump
		$AnimatedSprite.play("Jump")
		velocity += Vector2.DOWN * earth_gravity * low_jump_gravity_scale * delta

	if on_floor:
		
		if velocity.x == 0:
			$AnimatedSprite.play("default")
			
		if Input.is_action_just_pressed("ui_accept"): 
			velocity = Vector2.UP * jump_power #Normal Jump action
			$AnimatedSprite.play("Jump")
			jump_released = false

	velocity = move_and_slide(velocity, Vector2.UP) 

	if is_on_floor(): on_floor = true
	else: on_floor = false
	
	
func _on_body_entered(_body):
	velocity = 1
