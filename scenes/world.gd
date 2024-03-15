extends Node2D

@onready var cam: Camera = get_node("CameraStick/Camera")
@onready var game_over = preload("res://scenes/ui/menus/game_over.tscn")
@onready var game_stats: GameStats = preload("res://resources/game_stats.tres")


func _ready():
	game_stats.load_save()
	var p: Player = get_tree().get_first_node_in_group("Player")
	p.hurtbox.hit.connect(func(_val): cam.apply_shake(10.0))
	p.health_component.no_hp.connect(func(): 
		cam.apply_shake(100.0)
		cam.track_aim = false
		add_child(game_over.instantiate())
	)

