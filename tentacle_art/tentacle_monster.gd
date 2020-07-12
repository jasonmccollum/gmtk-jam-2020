extends Node2D

export var weight_scale = 10
export var min_angle = -5
export var max_angle = 5

var player = null
onready var root = $Skeleton2D/base

var bones = []
var bone_depth = {}
var min_bone_depth = 100000000
var max_bone_depth = -10000000

func _ready():
	build_skeleton()

func build_skeleton():
	var bones_stack = [root]
	
	while bones_stack.size():
		var bone = bones_stack.pop_front()
		bones.append(bone)
		var depth = float(str(get_path_to(bone)).split('/').size())
		bone_depth[bone.name] = depth
		max_bone_depth = max(max_bone_depth, depth)
		min_bone_depth = min(min_bone_depth, depth)
		for child in bone.get_children():
			bones_stack.append(child)

func set_player(p):
	player = p

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !player:
		return
	else:
		if(position.x < player.position.x):
			position.x += 0.7
		else:
			position.x -= 0.7
		
		var root = get_tree().get_root().get_node("world")
		if(position.y > 1100 - (root.sanity_manager.current_insanity*3)):
			position.y -= 0.5
		
	for bone in bones:
		var depth = bone_depth[bone.name]
		if depth == min_bone_depth:
			continue
		else:
			var weight = (depth - min_bone_depth) / (max_bone_depth - min_bone_depth) * weight_scale
			var sigmoid_weight = get_sigmoid(weight)
			var new_rotation = clamp(bone.get_angle_to(player.global_position), deg2rad(min_angle), deg2rad(max_angle))
			bone.rotation = lerp(bone.rotation, new_rotation, sigmoid_weight * delta)
			
func get_sigmoid(x, k=10, a=2, offset=-0.5):
	return (1 / pow((1 + exp(-(x + offset) * k)), a)) + 0.1
