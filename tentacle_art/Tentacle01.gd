extends Node2D

var player = null

onready var tip = $Skeleton2D/root/base/mid1/mid2/mid3/tip
onready var mid3 = $Skeleton2D/root/base/mid1/mid2/mid3

func _ready():
	player = get_parent().get_node("Player")

func _process(delta):
	if player:
		look_towards_player()
		
func look_towards_player():
	var offset = player.position - global_position
	var distance = offset.length()

	var joint_angle_0
	var joint_angle_1

	var atan_val = atan2(offset.y, offset.x)

	var length_0 = tip.default_length
	var length_1 = mid3.default_length

	# it's too far away
	if length_0 + length_1 < distance:
		joint_angle_0 = atan_val
		joint_angle_1 = 0
	else:
		var angle_0 = law_of_cos(distance, length_0, length_1)
		var angle_1 = law_of_cos(length_1, length_0, distance)

		joint_angle_0 = atan_val - angle_0
		joint_angle_1 = PI - angle_1

	tip.rotation = joint_angle_1
	mid3.rotation = joint_angle_0

func law_of_cos(a, b, c):
	if 2 * a * b == 0:
		return 0
	return acos( (a * a + b * b - c * c) / (2 * a * b) )
