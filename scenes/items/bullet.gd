extends Node2D

var effects_player_scene := preload("res://scenes/effects/effects_player.tscn")
var sound_scene = preload("res://scenes/effects/sounds/bullet_impact.tscn")

@export var speed := 900
@export var damage := 1

@onready var hitbox: Hitbox = %Hitbox


# Called when the node enters the scene tree for the first time.
func _ready():
	hitbox.knockback_direction = Vector2.from_angle(global_rotation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.x * speed * delta


func _on_hitbox_area_entered(_area: Hurtbox):
	impact()


func _on_hitbox_body_entered(_body):
	impact()


func impact():
	if is_queued_for_deletion():
		return
	_impact_effect()
	_impact_sound()
	queue_free()


func _impact_effect():
	var effectsPlayer = effects_player_scene.instantiate()
	get_tree().root.add_child(effectsPlayer)
	effectsPlayer.global_position = global_position
	effectsPlayer.scale = Vector2(0.5, 0.5)
	effectsPlayer.effects.play("circle_explosion")


func _impact_sound() -> void:
	var sound = sound_scene.instantiate()
	get_parent().add_child(sound)
	sound.global_position = global_position
	sound.connect("finished", func(): sound.queue_free())


func _on_timer_timeout():
	_impact_effect()
	queue_free()
