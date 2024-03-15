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

func _ready():
	Lobby.player_loaded.rpc_id(1)

func set_player_name(player_name: String):
	%NameTag.text = player_name

func _physics_process(delta: float):
	if is_multiplayer_authority():
		var mouse_pos = get_global_mouse_position()
		_handle_movement(delta)
		_handle_gun()
		_handle_sprite_rotations(mouse_pos)
		_sync_everything()


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
	# _sync_pos.rpc(global_position)
	
func _sync_everything():
	_sync.rpc(
			global_position,
			sprite.scale.x,
			gun.scale.y,
			gun.get_parent().rotation
	)

@rpc("any_peer", "call_local", "reliable", 0)
func _sync(pos: Vector2, spritex: float, guny: float, gun_rot: float):
	global_position = pos
	sprite.scale.x = spritex
	gun.scale.y = guny
	gun.get_parent().rotation = gun_rot


func _handle_sprite_rotations(mouse_pos: Vector2):
	var dir = mouse_pos - global_position

	if dir.x >= 0:
		sprite.scale.x = 1
		gun.scale.y = 1
	else:
		sprite.scale.x = -1
		gun.scale.y = -1

	
func _handle_gun():
	var turn_center = gun.get_parent()
	var dir = turn_center.global_position.direction_to(get_global_mouse_position())
	turn_center.rotation = dir.angle()
	if Input.is_action_pressed("primary"):
		gun.shoot.rpc()


func die():
	_die.rpc()

@rpc("any_peer", "call_local", "reliable", 0)
func _die():
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
