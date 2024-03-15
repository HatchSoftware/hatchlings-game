extends Control

@onready var player_list: ItemList = %PlayerList
@onready var start_game_btn: Button = %StartGame

@onready var world_scene := preload("res://scenes/world.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Lobby.player_connected.connect(func(_id, _info): _refresh_player_list())
	Lobby.player_disconnected.connect(func(_id, _info): _refresh_player_list())
	_refresh_player_list()
	if !multiplayer.is_server():
		start_game_btn.hide()

func _refresh_player_list():
	player_list.clear()
	for p in Lobby.players:
		var info = Lobby.players[p]
		var text = info.name
		if p == multiplayer.get_unique_id():
			text += " (You!)"
		player_list.add_item(text)

func _on_start_game_pressed():
	Lobby.load_game.rpc()

