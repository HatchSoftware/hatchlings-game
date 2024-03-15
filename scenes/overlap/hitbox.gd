class_name Hitbox
extends Area2D

@export var single_use := false
@export var damage := 1
# Because of this we can now also for example make launchpads!
@export var knockback_multiplier := 300.0
@export var knockback_direction := Vector2.ZERO

var used = false
