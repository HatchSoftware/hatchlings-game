extends CanvasLayer

@onready var world = preload("res://scenes/world.tscn")
@onready var game_stats: GameStats = preload("res://resources/game_stats.tres")

@onready var victory_sound: AudioStreamPlayer = %VictorySound
@onready var defeat_sound: AudioStreamPlayer = %DefeatSound


func _ready():
	game_stats.save_game()

	%Score.text = "Score: " + str(game_stats.score)
	%HighScore.text = "High Score: " + str(game_stats.high_score)

	if (game_stats.score == game_stats.high_score):
		%Title.text = "New High Score!"
		victory_sound.play()
	else:
		defeat_sound.play()

	%PlayAgain.pressed.connect(func(): 
			game_stats.reset()
			get_tree().change_scene_to_packed(world)
	)
