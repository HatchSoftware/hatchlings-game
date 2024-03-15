extends Control


@onready var player_name_text: TextEdit = %PlayerName
@onready var ip_text: TextEdit = %IP
@onready var port_text: TextEdit = %Port

@onready var player_list: ItemList = %PlayerList

var lobby_scene = preload("res://scenes/ui/lobby.tscn")


func _ready():
	# Lobby.player_connected.connect(func(_id, _info): _refresh_player_list())
	# Lobby.player_disconnected.connect(func(_id, _info): _refresh_player_list())
	# start_lobby_screen()
	pass

func start_lobby_screen():
	get_tree().change_scene_to_packed(lobby_scene)

func _refresh_player_list():
	player_list.clear()
	for p in Lobby.players:
		var info = Lobby.players[p]
		var text = info.name
		if p == multiplayer.get_unique_id():
			text += " (You!)"
		player_list.add_item(text)
	pass


func _on_join_btn_pressed():
	Lobby.player_info = {
		"name": player_name_text.text
	}
	Lobby.join_game(ip_text.text, int(port_text.text))
	start_lobby_screen()



func _on_host_btn_pressed():
	Lobby.player_info = {
		"name": player_name_text.text
	}
	Lobby.create_game(int(port_text.text))
	start_lobby_screen()

