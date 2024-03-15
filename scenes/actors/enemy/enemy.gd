extends CharacterBody2D

@export var game_stats: GameStats = preload("res://resources/game_stats.tres")

var death_sound_scene = preload("res://scenes/effects/sounds/yoda_death_sound.tscn")
var effects_player_scene = preload("res://scenes/effects/effects_player.tscn")
var item_drop_scene = preload("res://scenes/items/coffee_item.tscn")

var player: Player = null
@onready var vel: VelocityComponent = $VelocityComponent
@onready var hitbox: Hitbox = %Hitbox


func _physics_process(delta):
	velocity += vel.knockback
	if player != null:
		var direction = to_local(player.global_position).normalized()
		velocity = velocity.move_toward(direction * vel.max_speed, vel.acceleration * delta)

		hitbox.knockback_direction = direction

		# Sprite rotations
		if direction.x > 0:
			%Body.scale.x = 1
		elif direction.x < 0:
			%Body.scale.x = -1
	else:
		# Here we can also make the enemy wander around
		# State machines are preferable if you start doing such things
		velocity = velocity.move_toward(Vector2.ZERO, vel.friction * delta)

	move_and_slide()


func die():
	game_stats.score += 1

	if game_stats.score % 5 == 0:
		var item = item_drop_scene.instantiate()
		item.global_position = global_position
		get_parent().add_child(item)

	_play_death_sound()
	_play_bleed_effect()
	queue_free()


func _play_death_sound() -> void:
	var death_sound = death_sound_scene.instantiate()
	get_parent().add_child(death_sound)
	death_sound.global_position = global_position
	death_sound.connect("finished", func(): death_sound.queue_free())


func _play_bleed_effect() -> void:
	var effects_player = effects_player_scene.instantiate()
	get_tree().root.add_child(effects_player)
	effects_player.global_position = global_position
	effects_player.effects.play("bleed")


func _on_player_detection_body_entered(body):
	if body is Player:
		player = body


func _on_player_detection_body_exited(body: Node2D):
	if body is Player:
		player = null
