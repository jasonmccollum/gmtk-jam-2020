extends Node2D

export var scroll_rate = 100

onready var backgrounds = []
onready var screen_bottom = get_viewport_rect().size.y

var background_scene = preload("res://background/background.tscn")

var background_textures = [
	preload("res://background/background01.png"),
	preload("res://background/background02.png"),
	preload("res://background/background03.png"),
	preload("res://background/background04.png"),
	preload("res://background/background05.png")
]

var background_normals = [
	preload("res://background/background01_n.png"),
	preload("res://background/background02_n.png"),
	preload("res://background/background03_n.png"),
	preload("res://background/background04_n.png"),
	preload("res://background/background05_n.png")
]

func _ready():
	init_backgrounds()

func init_backgrounds():
	for i in range(3):
		generate_background(true, -i * 1920)

func _process(delta):
	for i in range(backgrounds.size()):
		var background = backgrounds[i]
		background.position.y += scroll_rate * delta

		if background.position.y - background.texture.get_height() > screen_bottom * 2:
			generate_background()
			backgrounds.remove(backgrounds.find(background))
			background.queue_free()
			
func generate_background(manually_set_y=false, y=0):
	var bg = background_scene.instance()
	var index = randi() % background_textures.size()
	bg.texture = background_textures[index]
	bg.normal_map = background_normals[index]
	if manually_set_y:
		bg.position.y = y
	else:
		bg.position.y = backgrounds[backgrounds.size() - 1].position.y - (backgrounds[backgrounds.size() - 1].texture.get_height() / 2) - (bg.texture.get_height() / 2)
	backgrounds.append(bg)
	add_child(bg)
