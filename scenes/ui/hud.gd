extends CanvasLayer

@export var health_component: HealthComponent
@export var game_stats: GameStats = preload("res://resources/game_stats.tres")


# Called when the node enters the scene tree for the first time.
func _ready():
	health_component.hp_changed.connect(_set_hp)
	game_stats.score_changed.connect(_set_score)
	_set_hp(health_component.hp)
	_set_score(game_stats.score)
	print("HUD", game_stats.high_score, game_stats.score)


func _set_hp(val: int):
	%HP.text = "HP: " + str(val)


func _set_score(val: int):
	%Score.text = "SCORE: " + str(val)
