extends Node2D

# var img = Image.new()
# var crosshair := preload("res://assets/crosshair.png")


func _physics_process(delta):
	global_position = get_global_mouse_position().round()


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
# Input.set_custom_mouse_cursor(crosshair, Input.CURSOR_ARROW, Vector2(15,15))

# func set_cursor():
# img.load("res://assets/crosshair.png")
