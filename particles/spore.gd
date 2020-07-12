extends CPUParticles2D

export var move_speed = 100
export var max_y = 1600

var death_scene = preload("res://particles/sporedeath.tscn")

var flashlight_ref = null

export var is_tentacle_spore = false

func _physics_process(delta):
	if flashlight_ref:
		if flashlight_ref.visible and !is_tentacle_spore:
			die()

	if!("tip" in get_parent().name):
		position.y -= move_speed * delta
	
	if position.y >= max_y:
		queue_free()

func die():
	var deathspore = death_scene.instance()
	deathspore.global_position = global_position
	get_parent().add_child(deathspore)
	queue_free()

func _on_Area2D_body_entered(body):
	if(body.name == "player"):
		var root = get_tree().get_root().get_node("world")
		if("tip" in get_parent().name):
			root.sanity_manager.change_insanity(1000)
			root.player.playerDead = true
		else:
			root.sanity_manager.change_insanity(10)
		die()

func _on_Area2D_area_entered(area):
	var is_on_flashlight = area.get_parent().name == 'flashlight' and area.get_parent().visible
	var is_torch = area.get_parent().name == 'flashlight' and area.get_parent().get("activated")

	if area.get_parent().name == 'flashlight':
		flashlight_ref = area.get_parent()

	if (is_on_flashlight or is_torch) and !is_tentacle_spore:
		die()
