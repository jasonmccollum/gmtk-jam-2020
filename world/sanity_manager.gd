extends Node2D

onready var sanityBar = $SanityBar

signal update_insanity(new_insanity)

export var max_insanity = 100

var current_insanity = 0

func _ready():
	connect("timeout", self, "_on_Timer_timeout")
	
#func _process(delta):
	#change_insanity(delta)

func change_insanity(delta: float):
	current_insanity += delta
	current_insanity = clamp(current_insanity, 0, max_insanity)
	sanityBar.setSanity(current_insanity)
	
	emit_signal("update_insanity", current_insanity)
