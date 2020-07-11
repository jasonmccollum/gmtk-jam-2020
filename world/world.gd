extends Node2D

onready var music_manager = $music_manager
onready var sanity_manager = $sanity_manager
onready var insanity_shader = $insanity_shader

onready var max_insanity = sanity_manager.max_insanity

func _ready():
	sanity_manager.connect("update_insanity", music_manager, 'update_insanity')
	sanity_manager.connect("update_insanity", insanity_shader, 'update_insanity')

	music_manager.max_insanity = max_insanity
	insanity_shader.max_insanity = max_insanity
