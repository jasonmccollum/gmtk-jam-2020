extends Sprite

export var min_size = 2
export var max_size = 4
export var max_delta = 2

var player_is_within = false
var activated = false

func _process(delta):
	$Light2D.scale = Vector2.ONE * clamp(rand_range(min_size, max_size), $Light2D.scale.x - max_delta*delta, $Light2D.scale.x + max_delta*delta)
	if(player_is_within and activated):
		var root = get_tree().get_root().get_node("world")
		root.sanity_manager.change_insanity(-delta / 2)

func activate():
	$Label.visible = false
	$fire2.visible = true
	$Light2D.visible = true
	activated = true
	$AudioStreamPlayer2D.play()

func _unhandled_input(event):
	if event.is_action_pressed("interact") and player_is_within and !activated:
		activate()

func _on_interaction_area_body_entered(body):
	if body.name == 'player':
		player_is_within = true
		if !activated:
			$Label.visible = true

func _on_interaction_area_body_exited(body):
	if body.name == 'player':
		player_is_within = false
		$Label.visible = false
