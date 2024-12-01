extends Control
class_name StartScreen
signal start_game(game_context: Array)

func get_user_attributes() -> Dictionary:
	return {
		'name':get_node("UserDetailsPanel/NameLineEdit").text
	}
	
func get_ipv4():
	var ipv4: String = $ConnectionDetailsPanel/ipv4LineEdit.text
	if ipv4.is_valid_ip_address():
		return ipv4
	elif ipv4.is_empty():
		return '127.0.0.1'

func set_game_types(list_of_game_types:Array[String]):
	for game_type in list_of_game_types:
		
		$DemoSelector.add_item(game_type)
func get_game_type():
	return $DemoSelector.get_item_text($DemoSelector.selected)

func _on_host_button_pressed():
	var game_context = {
		"user":get_user_attributes(),
		"conn":{
			'type':'host',
			'port':6767
		}, 
		"game_type":get_game_type()
	}
	emit_signal("start_game", game_context)

func _on_client_button_pressed():
	var game_context = {
		"user":get_user_attributes(),
		"client":{
			'type':'client',
			'ipv4':get_ipv4(),
			'port':6767
		}, 
		"game_type":get_game_type()
	}
	emit_signal("start_game", game_context)
	
	
