extends Node2D

@onready var sound: PackedScene = preload("res://scenes/effects/sounds/drink_sound.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func _on_player_detection_body_entered(body: Node2D):
	if body is Player:
		var player = body as Player
		player.gun.reduce_cooldown()
		# player.health_component.hp += 1

		var s: AudioStreamPlayer2D = sound.instantiate()
		get_parent().add_child(s)
		s.global_position = global_position
		s.connect("finished", func(): s.queue_free())

		# temporarily give the player a speed boost!
		player.velocity_component.max_speed += 50
		get_tree().create_timer(1.5).timeout.connect(
			func(): 
				if player: 
					player.velocity_component.max_speed -= 50
		)

		queue_free()
