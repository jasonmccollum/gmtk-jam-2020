extends Node2D

signal update_insanity(new_insanity)

export var max_insanity = 100

var current_insanity = 0

func _input(event):
	if event.is_action_pressed("up"):
		change_insanity(10)
	elif event.is_action_pressed("down"):
		change_insanity(-10)

func change_insanity(delta: float):
	current_insanity += delta
	current_insanity = clamp(current_insanity, 0, max_insanity)
	emit_signal("update_insanity", current_insanity)
	print(current_insanity)
