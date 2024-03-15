class_name Player
extends CharacterBody2D

# Components
@onready var velocity_component: VelocityComponent = %VelocityComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var hurtbox: Hurtbox = %Hurtbox
@onready var gun: Gun = %Gun

@onready var sprite := %Sprite
var player_hurt_sound_scene: PackedScene = preload("res://scenes/effects/sounds/player_hurt.tscn")
var player_died_sound_scene: PackedScene = preload("res://scenes/effects/sounds/player_died.tscn")

var mouse_pos: Vector2 = Vector2.ZERO


func _physics_process(delta: float):
	mouse_pos = get_global_mouse_position()
	_handle_movement(delta)
	_handle_gun()
	_handle_sprite_rotations()


func _handle_movement(delta):
	var input_vector = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("backward") - Input.get_action_strength("forward")
	)

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		velocity = velocity.move_toward(
			input_vector * velocity_component.max_speed, velocity_component.acceleration * delta
		)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, velocity_component.friction * delta)

	velocity += velocity_component.knockback

	move_and_slide()


func _handle_sprite_rotations():
	var dir = mouse_pos - global_position

	if dir.x >= 0:
		sprite.scale.x = 1
		gun.scale.y = 1
	else:
		sprite.scale.x = -1
		gun.scale.y = -1

	pass


func _handle_gun():
	var turn_center = gun.get_parent()
	var dir = turn_center.global_position.direction_to(get_global_mouse_position())
	turn_center.rotation = dir.angle()
	if Input.is_action_pressed("primary"):
		gun.shoot()


func die():
	var s = player_died_sound_scene.instantiate()
	get_parent().add_child(s)
	s.global_position = global_position
	s.connect("finished", func(): s.queue_free())

	queue_free()


func _on_hurtbox_hit(_val: int):
	var s = player_hurt_sound_scene.instantiate()
	get_parent().add_child(s)
	s.global_position = global_position
	s.connect("finished", func(): s.queue_free())
