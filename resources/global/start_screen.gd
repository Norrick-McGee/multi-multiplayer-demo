extends Control

const PORT = 6767

@export var Main: Node

func get_player_attributes() -> Dictionary:
	return {
		'name':get_node("PlayerDetailsPanel/NameLineEdit").text
	}

func get_ipv4():
	# TODO: get_node("ConnectionDetailsPanel/ipv4LineEdit").text validation
	return '127.0.0.1'

func _on_host_button_pressed():
	# init multiplayer
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer 
	print("Multiplayer Started")

	# start game
	Main.start_game('host', get_player_attributes())


func _on_client_button_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(get_ipv4(),PORT)
	multiplayer.multiplayer_peer = peer 
	Main.start_game('client', get_player_attributes())
