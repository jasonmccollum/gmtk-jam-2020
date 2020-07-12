extends Button

var mouse_over
var mouse_in
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():


	pass # Replace with function body.
func _pressed ( ):
	get_tree().change_scene("res://Screens/Narrative/NarrativeScreen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_mouse_entered():
	set_scale(Vector2(1.2,1.2))
	get_node("Label").add_color_override("font_color", Color( 1, 1, 0, 1 ))
	get_node("Label").text = "GOODBYE"
	pass # Replace with function body.


func _on_Button_mouse_exited():
	set_scale(Vector2(1,1))
	get_node("Label").add_color_override("font_color", Color( 1, 1, 0, 1 ))
	get_node("Label").text = "BEGIN"
	pass # Replace with function body.
