extends KinematicBody2D

export (int) var speed = 200

#distorted view, phantom stuff, involuntary movement, cant hold onto vines
var insanityLevel = 0
var insaneMoveCount = 0
const baseInsanityMovement = 2
var isInsane = false

var velocity = Vector2()
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
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
	else:
		HandleNormalMovement()

func HandleNormalMovement():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	
	velocity = velocity.normalized() * speed

func HandleInsaneMovement():
	velocity.x = randf()*2.0-1.0
	velocity.y = randf()*2.0-1.0
	velocity = velocity.normalized() * (speed) * (insanityLevel)
	
	insaneMoveCount+=1
	if(insaneMoveCount >= 30):
		isInsane = false
		insaneMoveCount = 0
		

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	
func _on_body_entered(_body):
	velocity = 1
