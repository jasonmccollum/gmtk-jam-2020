extends Node2D

export var max_insanity = 100
export var insanity_0_level = 0.0
export var insanity_1_level = 25.0
export var insanity_2_level = 50.0
export var insanity_3_level = 75.0

var current_insanity = 0

func update_insanity(amount):
	current_insanity = amount
	current_insanity = clamp(current_insanity, 0, max_insanity)
	transition_audio()
	
func transition_audio():
	var volume_0 = clamp(lerp(1, 0, current_insanity / insanity_1_level), 0, 1)
	var volume_1 = clamp(lerp3(0, 1, 0, current_insanity / insanity_2_level), 0, 1)
	var volume_2 = clamp(lerp3(0, 1, 0, (current_insanity - insanity_1_level) / insanity_2_level), 0, 1)
	var volume_3 = clamp(lerp3(0, 1, 1, (current_insanity - insanity_2_level) / insanity_2_level), 0, 1)

	$insanity0.volume_db = linear2db(volume_0)
	$insanity1.volume_db = linear2db(volume_1)
	$insanity2.volume_db = linear2db(volume_2)
	$insanity3.volume_db = linear2db(volume_3)

func lerp3(a, b, c, f):
	if f <= 0.5:
		return lerp(a, b, f * 2)
	
	return lerp(b, c, (f * 2) - 1)
