extends Node2D

export var move_speed = 100

onready var player = $player
onready var music_manager = $music_manager
onready var sanity_manager = $sanity_manager
onready var insanity_shader = $insanity_shader
onready var platform_generator = $platform_generator
onready var ladder_generator = $ladder_generator
onready var scrolling_background = $scrolling_background
onready var monsters = $monsters
onready var sanity_bar = $sanity_bar

onready var max_insanity = sanity_manager.max_insanity

func _ready():
	sanity_manager.connect("update_insanity", music_manager, 'update_insanity')
	sanity_manager.connect("update_insanity", insanity_shader, 'update_insanity')
	sanity_manager.connect("update_insanity", player, "update_insanity")

	music_manager.max_insanity = max_insanity
	insanity_shader.max_insanity = max_insanity
	sanity_manager.sanityBar = sanity_bar

	platform_generator.set_move_speed(move_speed)
	ladder_generator.set_move_speed(move_speed)
	scrolling_background.scroll_rate = move_speed
	player.scroll_speed = move_speed
	
	for monster in monsters.get_children():
		monster.set_player(player)

func update_flashlight_state():
	$flashlight_meter.value = player.get_node("flashlight").get("current_charge")

func _physics_process(delta):
	platform_generator.move_platforms(delta)
	ladder_generator.move_ladders(delta)
	var speed = sanity_manager.current_insanity*2 + 50
	platform_generator.move_speed = speed
	ladder_generator.move_speed = speed
	scrolling_background.scroll_rate = speed
	update_flashlight_state()
