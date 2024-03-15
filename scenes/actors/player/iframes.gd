extends Node

@onready var blink_animation_player: AnimationPlayer = $BlinkAnimationPlayer

func _on_hurtbox_iframes_ended():
	blink_animation_player.play("RESET")

func _on_hurtbox_iframes_started():
	blink_animation_player.play("Blink")


