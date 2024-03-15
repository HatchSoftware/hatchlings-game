class_name VelocityComponent
extends Node

@export var max_speed: int = 250
@export var acceleration: int = 5000
@export var friction: int = 5000

var knockback: Vector2


func apply_knockback(dir: Vector2, weight: float):
	knockback += dir * weight


func _physics_process(delta):
	knockback = lerp(knockback, Vector2.ZERO, delta * 20)
