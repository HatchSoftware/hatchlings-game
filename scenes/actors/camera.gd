extends Camera2D
class_name Camera

@export_group("Aiming")
@export var track_aim = true:
	set(val):
		track_aim = val
@export_range(1, 15, 0.5, "or_greater") var aim_scale := 6.0

@export_group("Screen shake")
@export var shake_speed: float = 3
@export var shake_decay: float = 5

@onready var rand = RandomNumberGenerator.new()
@onready var noise = FastNoiseLite.new()

var noise_pos: float = 0
var trauma: float = 0


func _ready() -> void:
	rand.randomize()
	noise.seed = rand.randi()
	noise.frequency = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if track_aim:
		_update_camera_position()

	trauma = lerp(trauma, 0.0, shake_decay * delta)
	self.offset = _get_offset_from_noise(delta)


func apply_shake(strength: float):
	trauma = max(trauma, strength)


func _update_camera_position() -> void:
	var mouse = get_local_mouse_position()
	var aim = mouse / aim_scale

	position.x = aim.x
	position.y = aim.y

	# Round camera position to avoid jitter for pixel-perfect movement
	position = position.round()


func _get_offset_from_noise(delta: float) -> Vector2:
	noise_pos += delta * shake_speed
	return Vector2(
		noise.get_noise_2d(0, noise_pos) * trauma, noise.get_noise_2d(10, noise_pos) * trauma
	)
