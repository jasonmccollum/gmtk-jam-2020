extends Node2D

onready var player = get_parent().get_node("Player")
onready var root = $Skeleton2D/root

var bone_depth = {}
var min_bone_depth = 100000000
var max_bone_depth = -10000000

func _ready():
	build_skeleton()
	print(bone_depth)
	print(min_bone_depth)
	print(max_bone_depth)

func build_skeleton():
	var bones_stack = [root]
	
	while bones_stack.size():
		var bone = bones_stack.pop_front()
		var depth = str(get_path_to(bone)).split('/').size()
		bone_depth[bone.name] = depth
		max_bone_depth = max(max_bone_depth, depth)
		min_bone_depth = min(min_bone_depth, depth)
		for child in bone.get_children():
			bones_stack.append(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	tip.look_at(player.position)
#	mid2.rotation = lerp(mid2.rotation, mid2.get_angle_to(player.position), mid2_strength * delta)
#	mid3.rotation = lerp(mid3.rotation, mid3.get_angle_to(player.position), mid3_strength * delta)
