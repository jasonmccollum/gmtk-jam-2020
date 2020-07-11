extends ColorRect

export var wave_min_insanity = 50
export var wave_max_insanity = 100
export var pixelation_min_insanity = 25
export var pixelation_max_insanity = 100

export var wave_max_frequency = 50.0
export var wave_max_depth = 0.002
export var pulse_rate_max = 1.0
export var pixelation_size_min = 0.002
export var pixelation_size_x = 0.008
export var pixelation_size_y = 0.008
export var pixelation_size_x_min = 0.001
export var pixelation_size_y_min = 0.001

var pixelation_size_min_min = 0.001

var current_wave_frequency = 0.0
var current_wave_depth = wave_max_depth
var current_pulse_rate = 0.0
var current_pixelation_size_min = 0.000
var current_pixelation_size_x = pixelation_size_x_min
var current_pixelation_size_y = pixelation_size_y_min
var vignette_mix_amount = 0.0

var current_insanity = 0
var max_insanity = 100

onready var mat = self.get_material()

func _ready():
	update_shader_params()

func update_insanity(amount):
	current_insanity = amount
	set_shader_params()

func set_shader_params():
	vignette_mix_amount = lerp(0, 1, current_insanity / max_insanity)
	current_wave_frequency = lerp(0, wave_max_frequency, clamp((current_insanity - wave_min_insanity) / (wave_max_insanity - wave_min_insanity), 0, 1))
	current_pixelation_size_x = lerp(pixelation_size_x_min, pixelation_size_x, clamp((current_insanity - pixelation_min_insanity) / (pixelation_max_insanity - pixelation_min_insanity), 0, 1))
	current_pixelation_size_y = lerp(pixelation_size_y_min, pixelation_size_y, clamp((current_insanity - pixelation_min_insanity) / (pixelation_max_insanity - pixelation_min_insanity), 0, 1))
	current_pixelation_size_min = lerp(pixelation_size_min_min, pixelation_size_min, clamp((current_insanity - pixelation_min_insanity) / (pixelation_max_insanity - pixelation_min_insanity), 0, 1))
	update_shader_params()

func update_shader_params():
	mat.set_shader_param("depth", current_wave_depth)
	mat.set_shader_param("frequency", current_wave_frequency)
	mat.set_shader_param("pulse_rate", current_pulse_rate)
	mat.set_shader_param("min_size", current_pixelation_size_min)
	mat.set_shader_param("size_x", current_pixelation_size_x)
	mat.set_shader_param("size_y", current_pixelation_size_y)
	mat.set_shader_param("vignette_mix_amount", vignette_mix_amount)
