extends CPUParticles2D



export var move_speed = 100
export var max_y = 1600

func _physics_process(delta):
	if!("tip" in get_parent().name):
		position.y -= move_speed * delta
	
	if position.y >= max_y:
		queue_free()


func _on_Area2D_body_entered(body):
	if(body.name == "player"):
		var root = get_tree().get_root().get_node("world")
		if("tip" in get_parent().name):
			root.sanity_manager.change_insanity(1000)
			root.player.playerDead = true
		else:
			root.sanity_manager.change_insanity(10)
		queue_free()
