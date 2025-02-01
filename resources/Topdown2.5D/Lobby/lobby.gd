extends Control

@export var chat_box: ChatBox
@export var charcter_sheets: CharacterSheetMan

var client_context: Dictionary = {}
func set_game_context(context: Dictionary):
	"""
	This function is expected by Multi-Multiplayer-Demo.Main, and is called to
	any scene that is started by Main (assuming the game has this function) 
	"""
	client_context = context
	context['netman'].connect('player_connecting', _player_connecting)
	context['netman'].auto_admit=true

func _ready():
	if chat_box == null:
		print("DEBUG: Chatbox is not defined from @export, using default")
		chat_box = $MainPanel/VBoxContainer/ChatBox 

func _player_connecting(player_id):
	pass
