extends Node2D
class_name Gun

var bullet = preload("res://scenes/items/bullet.tscn")
@onready var cooldown: Timer = %Cooldown


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func reduce_cooldown():
	cooldown.wait_time = max(0.05, cooldown.wait_time - 0.01)

@rpc("any_peer", "call_local", "reliable", 0)
func shoot():
	if cooldown.is_stopped():
		print("shot", multiplayer.get_unique_id())
		var b: Node2D = bullet.instantiate()
		var pos = %Muzzle.global_position

		b.global_position = pos
		b.global_rotation = global_rotation

		get_tree().root.add_child(b)
		_play_sound()
		cooldown.start()


func _play_sound():
	%AudioStreamPlayer.play()
