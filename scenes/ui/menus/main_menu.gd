extends Control


@onready var player_name_text: TextEdit = %PlayerName
@onready var ip_text: TextEdit = %IP
@onready var port_text: TextEdit = %Port


var lobby_scene = preload("res://scenes/ui/lobby.tscn")


func start_lobby_screen():
	get_tree().change_scene_to_packed(lobby_scene)


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

