extends Control

@export var Main: Node
const DEFAULT_PORT = 6767

func get_player_attributes() -> Dictionary:
	return {
		'name':get_node("PlayerDetailsPanel/NameLineEdit").text
	}
func get_ipv4():
	var ipv4: String = $ConnectionDetailsPanel/ipv4LineEdit.text
	if ipv4.is_valid_ip_address():
		return ipv4
	elif ipv4.is_empty():
		return '127.0.0.1'
	

func _on_host_button_pressed():
	var game_context = {
		"player":get_player_attributes(),
		"client":{
			'type':'host',
			'port':DEFAULT_PORT
		}
	}
	Main.start_game(game_context)


func _on_client_button_pressed():
	var game_context = {
		"player":get_player_attributes(),
		"client":{
			'type':'client',
			'ipv4':get_ipv4(),
			'port':DEFAULT_PORT
		}
	}
	Main.start_game(game_context)
