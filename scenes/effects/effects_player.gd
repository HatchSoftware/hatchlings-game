extends Node2D

@onready var effects: AnimatedSprite2D = $Effects

func _on_effects_animation_finished():
	queue_free()

