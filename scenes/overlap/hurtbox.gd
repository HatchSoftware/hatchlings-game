class_name Hurtbox
extends Area2D

@export var iframes_enabled = false
@export var health_component: HealthComponent
@export var velocity_component: VelocityComponent

@onready var timer: Timer = %Timer

signal hit(val: int)
signal iframes_started
signal iframes_ended


func _ready():
	timer.timeout.connect(func(): iframes_ended.emit())


func _on_area_entered(area: Area2D):
	if area is Hitbox && (!iframes_enabled || (iframes_enabled && timer.is_stopped())):
		var hitbox = area as Hitbox
		if hitbox.single_use && hitbox.used:
			return

		# Invincibility frames
		if iframes_enabled:
			timer.start()
			iframes_started.emit()

		# Apply knockback
		if velocity_component:
			velocity_component.apply_knockback(
				hitbox.knockback_direction, hitbox.knockback_multiplier
			)

		# Deal damage
		if health_component:
			health_component.hp -= hitbox.damage
		hitbox.used = true
		hit.emit(hitbox.damage)
